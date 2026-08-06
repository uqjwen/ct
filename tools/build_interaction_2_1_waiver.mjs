#!/usr/bin/env node

import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { FileBlob, SpreadsheetFile } from "@oai/artifact-tool";


const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const workbookPath = path.join(root, "waive", "08-xxx_代码与功能覆盖率排除列表.xlsx");
const manifestPath = path.join(root, "waive", "interaction_2_1_code_waiver_manifest.csv");
const previewDir = path.join(root, ".artifacts", "interaction-2.1-waiver");


function parseCsv(text) {
  const rows = [];
  let row = [];
  let field = "";
  let quoted = false;
  for (let index = 0; index < text.length; index += 1) {
    const character = text[index];
    if (quoted) {
      if (character === '"' && text[index + 1] === '"') {
        field += '"';
        index += 1;
      } else if (character === '"') {
        quoted = false;
      } else {
        field += character;
      }
    } else if (character === '"') {
      quoted = true;
    } else if (character === ",") {
      row.push(field);
      field = "";
    } else if (character === "\n") {
      row.push(field.replace(/\r$/, ""));
      rows.push(row);
      row = [];
      field = "";
    } else {
      field += character;
    }
  }
  if (field || row.length) {
    row.push(field.replace(/\r$/, ""));
    rows.push(row);
  }
  const headers = rows.shift();
  return rows.filter((values) => values.some(Boolean)).map((values) =>
    Object.fromEntries(headers.map((header, index) => [header, values[index] ?? ""])),
  );
}


function workbookRow(row) {
  return [
    row.coverage_type,
    `${row.source_object}\n仓库映射：${row.repo_mapping}`,
    row.module,
    row.source_section,
    row.condition,
    row.reason,
    row.impact,
    row.alternative,
    row.property,
    row.term,
    "", "", "", "", "", "",
    row.remarks,
  ];
}


async function saveRender(workbook, sheetName, range, filename, scale = 1) {
  const preview = await workbook.render({ sheetName, range, scale, format: "png" });
  await fs.writeFile(
    path.join(previewDir, filename),
    new Uint8Array(await preview.arrayBuffer()),
  );
}


async function saveInitialRenderOnce(workbook, sheetName, range, filename) {
  const outputPath = path.join(previewDir, filename);
  try {
    await fs.access(outputPath);
  } catch {
    const preview = await workbook.render({ sheetName, range, scale: 1, format: "png" });
    await fs.writeFile(outputPath, new Uint8Array(await preview.arrayBuffer()));
  }
}


await fs.mkdir(previewDir, { recursive: true });
const manifest = parseCsv(await fs.readFile(manifestPath, "utf8"));
if (manifest.length <= 50) {
  throw new Error(`manifest has only ${manifest.length} rows`);
}

const input = await FileBlob.load(workbookPath);
const workbook = await SpreadsheetFile.importXlsx(input);
const codeSheet = workbook.worksheets.getItem("代码waiver");
const functionSheet = workbook.worksheets.getItem("功能waiver");

const before = await workbook.inspect({
  kind: "table",
  range: "代码waiver!A1:Q8",
  include: "values,formulas",
  tableMaxRows: 8,
  tableMaxCols: 17,
  maxChars: 5000,
});
console.log(before.ndjson);
await saveInitialRenderOnce(workbook, "代码waiver", "A1:Q10", "before-code.png");
await saveInitialRenderOnce(workbook, "功能waiver", "A1:Q6", "before-function.png");

codeSheet.getRange("A3:Q300").clear({ applyTo: "contents" });
functionSheet.getRange("A3:Q30").clear({ applyTo: "contents" });

const firstDataRow = 3;
const lastDataRow = firstDataRow + manifest.length - 1;
for (let rowNumber = firstDataRow; rowNumber <= lastDataRow; rowNumber += 1) {
  codeSheet.getRange(`A${rowNumber}:Q${rowNumber}`).copyFrom(
    codeSheet.getRange("A3:Q3"),
    "all",
  );
}
codeSheet.getRange(`A${firstDataRow}:Q${lastDataRow}`).values = manifest.map(workbookRow);

const body = codeSheet.getRange(`A${firstDataRow}:Q${lastDataRow}`);
body.format.wrapText = true;
body.format.verticalAlignment = "top";
for (let index = 0; index < manifest.length; index += 1) {
  const longest = Math.max(...workbookRow(manifest[index]).map((value) => value.length));
  const height = longest > 1200 ? 260 : longest > 700 ? 200 : longest > 400 ? 150 : longest > 220 ? 110 : 78;
  codeSheet.getRange(`A${firstDataRow + index}:Q${firstDataRow + index}`).format.rowHeight = height;
}
codeSheet.getRange(`A${firstDataRow}:A${lastDataRow}`).format.horizontalAlignment = "center";
codeSheet.getRange(`C${firstDataRow}:D${lastDataRow}`).format.horizontalAlignment = "center";
codeSheet.getRange(`I${firstDataRow}:J${lastDataRow}`).format.horizontalAlignment = "center";
codeSheet.getRange(`K${firstDataRow}:P${lastDataRow}`).format.horizontalAlignment = "center";

const widths = {
  A: 12, B: 42, C: 20, D: 14, E: 42, F: 48, G: 28, H: 32, I: 20,
  J: 18, K: 10, L: 12, M: 12, N: 12, O: 12, P: 12, Q: 34,
};
for (const [column, width] of Object.entries(widths)) {
  codeSheet.getRange(`${column}1:${column}${lastDataRow}`).format.columnWidth = width;
  functionSheet.getRange(`${column}1:${column}2`).format.columnWidth = width;
}
codeSheet.getRange("A1:Q2").format.wrapText = true;
functionSheet.getRange("A1:Q2").format.wrapText = true;
codeSheet.freezePanes.freezeRows(2);
functionSheet.freezePanes.freezeRows(2);

const afterFirst = await workbook.inspect({
  kind: "table",
  range: "代码waiver!A1:Q8",
  include: "values,formulas",
  tableMaxRows: 8,
  tableMaxCols: 17,
  maxChars: 6000,
});
console.log(afterFirst.ndjson);
const afterLast = await workbook.inspect({
  kind: "table",
  range: `代码waiver!A${lastDataRow - 3}:Q${lastDataRow}`,
  include: "values,formulas",
  tableMaxRows: 4,
  tableMaxCols: 17,
  maxChars: 4000,
});
console.log(afterLast.ndjson);
const functionCheck = await workbook.inspect({
  kind: "table",
  range: "功能waiver!A1:Q5",
  include: "values,formulas",
  tableMaxRows: 5,
  tableMaxCols: 17,
  maxChars: 3000,
});
console.log(functionCheck.ndjson);
const errors = await workbook.inspect({
  kind: "match",
  searchTerm: "#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A",
  options: { useRegex: true, maxResults: 300 },
  summary: "interaction-2.1 waiver formula error scan",
});
console.log(errors.ndjson);

await saveRender(workbook, "代码waiver", "A1:Q20", "after-code-first.png", 1);
await saveRender(
  workbook,
  "代码waiver",
  `A${Math.max(firstDataRow, lastDataRow - 14)}:Q${lastDataRow}`,
  "after-code-last.png",
  1,
);
await saveRender(workbook, "功能waiver", "A1:Q5", "after-function.png", 1);

const output = await SpreadsheetFile.exportXlsx(workbook);
await output.save(workbookPath);
await fs.rm(`${workbookPath}.inspect.ndjson`, { force: true });
console.log(`WAIVER_BUILDER_PASS rows=${manifest.length} workbook=${workbookPath}`);
