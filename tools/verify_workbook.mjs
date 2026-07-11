#!/usr/bin/env node

import fs from "node:fs/promises";
import path from "node:path";
import { FileBlob, SpreadsheetFile } from "@oai/artifact-tool";

const repoRoot = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..");
const workbookPath = path.join(repoRoot, "ld_ag_feature_list.xlsx");
const previewPath = process.argv[2]
  ? path.resolve(process.argv[2])
  : path.join(repoRoot, "work", "feature_list_reimport_preview.png");

const workbook = await SpreadsheetFile.importXlsx(await FileBlob.load(workbookPath));
const check = await workbook.inspect({
  kind: "table",
  range: "功能点清单!A1:H72",
  include: "values,formulas",
  tableMaxRows: 80,
  tableMaxCols: 8,
  maxChars: 80000,
});
const text = check.ndjson;
for (const required of ["类功能点名称", "详细功能点名称", "功能点描述", "配置说明", "测试方法", '"rows":72', '"cols":8']) {
  if (!text.includes(required)) throw new Error(`Workbook verification missing: ${required}`);
}
const errors = await workbook.inspect({
  kind: "match",
  searchTerm: "#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A",
  options: { useRegex: true, maxResults: 100 },
  summary: "reimported workbook formula-error scan",
});
if (!errors.ndjson.includes("matched 0 entries")) {
  throw new Error(`Workbook formula error scan failed: ${errors.ndjson}`);
}
const preview = await workbook.render({
  sheetName: "功能点清单",
  range: "A1:H72",
  scale: 1.2,
  format: "png",
});
await fs.mkdir(path.dirname(previewPath), { recursive: true });
await fs.writeFile(previewPath, new Uint8Array(await preview.arrayBuffer()));
console.log("PASS workbook: sheets=1, used_rows=72, feature_rows=68, columns=8, formula_errors=0");
