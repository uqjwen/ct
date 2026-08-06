#!/usr/bin/env node

import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { FileBlob, SpreadsheetFile } from "@oai/artifact-tool";


const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const workbookPath = path.join(root, "waive", "08-cp0_代码与功能覆盖率排除列表.xlsx");
const manifestPath = path.join(root, "waive", "interaction_2_2_cp0_code_waiver_manifest.csv");
const renderDir = path.join(root, ".artifacts", "interaction-2.2-cp0-waiver");


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
    row.source_object,
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


async function saveRender(workbook, sheetName, range, filename, scale = 1.5) {
  const preview = await workbook.render({ sheetName, range, scale, format: "png" });
  await fs.writeFile(
    path.join(renderDir, filename),
    new Uint8Array(await preview.arrayBuffer()),
  );
}


async function saveInitialRenderOnce(workbook, sheetName, filename) {
  const outputPath = path.join(renderDir, filename);
  try {
    await fs.access(outputPath);
  } catch {
    await saveRender(workbook, sheetName, "A1:Q12", filename, 1.5);
  }
}


function displayUnits(text) {
  let units = 0;
  for (const character of text) {
    units += character.codePointAt(0) > 0xff ? 2 : 1;
  }
  return units;
}


function rowHeight(values, widths) {
  const columns = Object.keys(widths);
  let lines = 1;
  for (let index = 0; index < values.length; index += 1) {
    const value = String(values[index] ?? "");
    const explicitLines = value.split("\n");
    const estimated = explicitLines.reduce(
      (total, part) => total + Math.max(1, Math.ceil(displayUnits(part) / widths[columns[index]])),
      0,
    );
    lines = Math.max(lines, estimated);
  }
  return Math.min(132, Math.max(36, 8 + lines * 15));
}


await fs.mkdir(renderDir, { recursive: true });
const manifest = parseCsv(await fs.readFile(manifestPath, "utf8"));
if (manifest.length !== 45) {
  throw new Error(`manifest row count differs: ${manifest.length} != 45`);
}

const input = await FileBlob.load(workbookPath);
const workbook = await SpreadsheetFile.importXlsx(input);
const codeSheet = workbook.worksheets.getItem("代码waiver");
const functionSheet = workbook.worksheets.getItem("功能waiver");

for (const sheetName of ["代码waiver", "功能waiver"]) {
  const table = await workbook.inspect({
    kind: "table",
    range: `${sheetName}!A1:Q12`,
    include: "values,formulas",
    tableMaxRows: 12,
    tableMaxCols: 17,
    tableMaxCellChars: 120,
    maxChars: 8000,
  });
  console.log(table.ndjson);
  const styles = await workbook.inspect({
    kind: "computedStyle",
    sheetId: sheetName,
    range: "A1:Q3",
    maxChars: 4000,
  });
  console.log(styles.ndjson);
}
await saveInitialRenderOnce(workbook, "代码waiver", "before-code-A1-Q12.png");
await saveInitialRenderOnce(workbook, "功能waiver", "before-function-A1-Q12.png");

codeSheet.getRange("A3:Q200").clear({ applyTo: "contents" });
functionSheet.getRange("A3:Q200").clear({ applyTo: "contents" });

for (let rowNumber = 4; rowNumber <= 47; rowNumber += 1) {
  codeSheet.getRange(`A${rowNumber}:Q${rowNumber}`).copyFrom(
    codeSheet.getRange("A3:Q3"),
    "all",
  );
}
const worksheetRows = manifest.map(workbookRow);
codeSheet.getRange("A3:Q47").values = worksheetRows;

const body = codeSheet.getRange("A3:Q47");
body.format.wrapText = true;
body.format.verticalAlignment = "top";
codeSheet.getRange("A3:A47").format.horizontalAlignment = "center";
codeSheet.getRange("C3:D47").format.horizontalAlignment = "center";
codeSheet.getRange("I3:J47").format.horizontalAlignment = "center";
codeSheet.getRange("K3:P47").format.horizontalAlignment = "center";

const widths = {
  A: 12, B: 42, C: 20, D: 18, E: 42, F: 48, G: 30, H: 38, I: 22,
  J: 20, K: 10, L: 12, M: 12, N: 12, O: 12, P: 12, Q: 36,
};
for (const [column, width] of Object.entries(widths)) {
  codeSheet.getRange(`${column}1:${column}47`).format.columnWidth = width;
  functionSheet.getRange(`${column}1:${column}5`).format.columnWidth = width;
}
for (let index = 0; index < worksheetRows.length; index += 1) {
  codeSheet.getRange(`A${index + 3}:Q${index + 3}`).format.rowHeight = rowHeight(
    worksheetRows[index],
    widths,
  );
}
codeSheet.getRange("A1:Q2").format.wrapText = true;
functionSheet.getRange("A1:Q2").format.wrapText = true;
await codeSheet.freezePanes.freezeRows(2);
await functionSheet.freezePanes.freezeRows(2);

const codeCheck = await workbook.inspect({
  kind: "table",
  range: "代码waiver!A1:Q47",
  include: "values,formulas",
  tableMaxRows: 47,
  tableMaxCols: 17,
  tableMaxCellChars: 120,
  maxChars: 24000,
});
console.log(codeCheck.ndjson);
const functionCheck = await workbook.inspect({
  kind: "table",
  range: "功能waiver!A1:Q5",
  include: "values,formulas",
  tableMaxRows: 5,
  tableMaxCols: 17,
  maxChars: 5000,
});
console.log(functionCheck.ndjson);
const errors = await workbook.inspect({
  kind: "match",
  searchTerm: "#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A",
  options: { useRegex: true, maxResults: 300 },
  summary: "interaction-2.2 CP0 waiver formula error scan",
});
console.log(errors.ndjson);

const output = await SpreadsheetFile.exportXlsx(workbook);
await output.save(workbookPath);
await fs.rm(`${workbookPath}.inspect.ndjson`, { force: true });

const renderedInput = await FileBlob.load(workbookPath);
const renderedWorkbook = await SpreadsheetFile.importXlsx(renderedInput);
await saveRender(renderedWorkbook, "代码waiver", "A1:Q14", "final-code-rows-1-14.png");
await saveRender(renderedWorkbook, "代码waiver", "A36:Q47", "final-code-rows-36-47.png");
await saveRender(renderedWorkbook, "功能waiver", "A1:Q5", "final-function-rows-1-5.png");
console.log(`CP0_WAIVER_BUILDER_PASS rows=${manifest.length}`);
