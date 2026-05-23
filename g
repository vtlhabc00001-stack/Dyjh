<!DOCTYPE html>
<html lang="zh-TW">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>大業國中平均成績計算器</title>
<style>
body {
font-family: 'PingFang TC', 'Microsoft JhengHei', sans-serif;
background-color: #f4f7f6;
color: #333;
display: flex;
justify-content: center;
align-items: center;
min-height: 100vh;
margin: 0;
}
.container {
background-color: white;
padding: 30px;
border-radius: 12px;
box-shadow: 0 4px 15px rgba(0,0,0,0.1);
width: 100%;
max-width: 450px;
}
h2 { text-align: center; color: #2c3e50; margin-top: 0; }
.form-group { margin-bottom: 12px; }
.form-group label { display: block; font-size: 14px; font-weight: bold; margin-bottom: 5px; color: #2c3e50; }
.form-group input[type="text"] { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; font-size: 16px; box-sizing: border-box; }
.subject-row { display: flex; gap: 10px; margin-bottom: 12px; align-items: center; }
input[type="text"] { flex: 2; padding: 10px; border: 1px solid #ddd; border-radius: 6px; font-size: 16px; }
input[type="number"] { flex: 1; padding: 10px; border: 1px solid #ddd; border-radius: 6px; font-size: 16px; }
button { cursor: pointer; padding: 10px 15px; border: none; border-radius: 6px; font-size: 14px; font-weight: bold; transition: background 0.2s; }
.btn-add { background-color: #3498db; color: white; width: 100%; margin-bottom: 20px; }
.btn-add:hover { background-color: #2980b9; }
.btn-calc { background-color: #2ecc71; color: white; width: 100%; font-size: 16px; padding: 12px; margin-bottom: 10px; }
.btn-calc:hover { background-color: #27ae60; }
.btn-print { background-color: #9b59b6; color: white; width: 100%; font-size: 16px; padding: 12px; display: none; }
.btn-print:hover { background-color: #8e44ad; }
.btn-del { background-color: #e74c3c; color: white; padding: 10px; }
.result-box { margin-top: 25px; padding: 15px; background-color: #ecf0f1; border-radius: 8px; text-align: center; display: none; }
.result-val { font-size: 24px; font-weight: bold; color: #2c3e50; margin: 5px 0; }
.comment { font-size: 14px; color: #7f8c8d; font-style: italic; }

/* 列印樣式 */
@media print {
body { background-color: white; }
.container { box-shadow: none; max-width: 100%; }
.btn-add, .btn-calc, .btn-print { display: none !important; }
.form-group { display: none !important; }
.result-box { display: none !important; }
#print-card { display: block !important; }
}

.print-card { display: none; margin-top: 20px; padding: 20px; border: 2px solid #2c3e50; background-color: #fff; }
.print-card.show { display: block; }
.print-header { text-align: center; border-bottom: 3px solid #2c3e50; padding-bottom: 15px; margin-bottom: 20px; }
.print-header h1 { margin: 0; color: #2c3e50; font-size: 28px; }
.print-header p { margin: 5px 0; color: #555; }
.print-info { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 20px; font-size: 14px; }
.print-info-item { padding: 10px; background-color: #ecf0f1; border-radius: 6px; }
.print-info-label { font-weight: bold; color: #2c3e50; }
.print-info-value { color: #555; margin-top: 3px; }
.print-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
.print-table th, .print-table td { border: 1px solid #2c3e50; padding: 10px; text-align: center; }
.print-table th { background-color: #3498db; color: white; font-weight: bold; }
.print-table tr:nth-child(even) { background-color: #ecf0f1; }
.print-summary { text-align: center; padding: 15px; background-color: #2ecc71; color: white; border-radius: 6px; margin-bottom: 15px; }
.print-summary-val { font-size: 20px; font-weight: bold; margin: 5px 0; }
.print-comment { text-align: center; padding: 15px; background-color: #f39c12; color: white; border-radius: 6px; margin-bottom: 15px; font-size: 16px; font-weight: bold; }
.print-footer { text-align: right; margin-top: 20px; color: #7f8c8d; font-size: 12px; }
</style>
</head>
<body>

<div class="container">
<h2>📊 平均成績計算器</h2>
<p style="text-align: center; color: #7f8c8d; font-size: 14px;">請輸入科目名稱與分數</p>

<div class="form-group">
<label for="student-name">學生姓名：</label>
<input type="text" id="student-name" placeholder="請輸入姓名">
</div>

<div class="form-group">
<label for="class-name">班級：</label>
<input type="text" id="class-name" placeholder="例：九年級甲班">
</div>

<div id="subject-list">
<div class="subject-row">
<input type="text" placeholder="科目" value="國文">
<input type="number" placeholder="分數" min="0" max="100" class="score-input">
<button class="btn-del" onclick="deleteRow(this)">❌</button>
</div>
<div class="subject-row">
<input type="text" placeholder="科目" value="數學">
<input type="number" placeholder="分數" min="0" max="100" class="score-input">
<button class="btn-del" onclick="deleteRow(this)">❌</button>
</div>
</div>

<button class="btn-add" onclick="addSubject()">＋ 新增科目</button>
<button class="btn-calc" onclick="calculateAverage()">🧮 計算平均成績</button>
<button class="btn-print" id="print-btn" onclick="printReport()">🖨️ 列印成績單</button>

<div class="result-box" id="result-box">
<div>總分：<span id="total-score">0</span></div>
<div class="result-val">平均：<span id="average-score">0</span> 分</div>
<div class="comment" id="comment-text"></div>
</div>

<!-- 列印成績單卡片 -->
<div class="print-card" id="print-card">
<div class="print-header">
<h1>🎓 大業國中成績單</h1>
<p>學生成績報告</p>
</div>

<div class="print-info">
<div class="print-info-item">
<div class="print-info-label">學生姓名</div>
<div class="print-info-value" id="print-name">-</div>
</div>
<div class="print-info-item">
<div class="print-info-label">班級</div>
<div class="print-info-value" id="print-class">-</div>
</div>
<div class="print-info-item">
<div class="print-info-label">科目數量</div>
<div class="print-info-value" id="print-count">0</div>
</div>
<div class="print-info-item">
<div class="print-info-label">統計日期</div>
<div class="print-info-value" id="print-date">-</div>
</div>
</div>

<table class="print-table">
<thead>
<tr>
<th>科目</th>
<th>分數</th>
</tr>
</thead>
<tbody id="print-table-body">
</tbody>
</table>

<div class="print-summary">
<div>總分：<span class="print-summary-val" id="print-total">0</span> 分</div>
<div>平均成績：<span class="print-summary-val" id="print-average">0</span> 分</div>
</div>

<div class="print-comment" id="print-comment-box"></div>

<div class="print-footer">
<p>列印時間：<span id="print-time">-</span></p>
</div>
</div>
</div>

<script>
function addSubject() {
const list = document.getElementById('subject-list');
const row = document.createElement('div');
row.className = 'subject-row';
row.innerHTML = `
<input type="text" placeholder="科目">
<input type="number" placeholder="分數" min="0" max="100" class="score-input">
<button class="btn-del" onclick="deleteRow(this)">❌</button>
`;
list.appendChild(row);
}

function deleteRow(button) {
button.parentElement.remove();
}

function calculateAverage() {
const scoreInputs = document.querySelectorAll('.score-input');
let total = 0;
let count = 0;

scoreInputs.forEach(input => {
const val = parseFloat(input.value);
if (!isNaN(val)) {
total += val;
count++;
}
});

if (count === 0) {
alert('請至少輸入一個分數！');
return;
}

const average = (total / count).toFixed(1);
document.getElementById('total-score').innerText = total;
document.getElementById('average-score').innerText = average;

let comment = "";
if (average >= 95) comment = "👑 太神了！這是頂尖高手的境界！";
else if (average >= 90) comment = "🔥 表現非常優異，繼續保持！";
else if (average >= 80) comment = "👍 很不錯喔！代表實力很紮實！";
else if (average >= 60) comment = "✨ 及格了，繼續努力往前衝！";
else comment = "💪 這次不小心手滑了，下次一定能贏回來！";

document.getElementById('comment-text').innerText = comment;
document.getElementById('result-box').style.display = 'block';
document.getElementById('print-btn').style.display = 'block';
}

function printReport() {
const scoreInputs = document.querySelectorAll('.score-input');
const subjectInputs = document.querySelectorAll('#subject-list .subject-row input[type="text"]');
let total = 0;
let count = 0;

// 填充表格資料
const tableBody = document.getElementById('print-table-body');
tableBody.innerHTML = '';

subjectInputs.forEach((subjectInput, index) => {
const scoreInput = scoreInputs[index];
const subject = subjectInput.value || '科目' + (index + 1);
const score = parseFloat(scoreInput.value) || 0;

if (scoreInput.value) {
total += score;
count++;

const row = document.createElement('tr');
row.innerHTML = `
<td>${subject}</td>
<td>${score}</td>
`;
tableBody.appendChild(row);
}
});

const average = count > 0 ? (total / count).toFixed(1) : 0;

// 填充成績單資訊
const studentName = document.getElementById('student-name').value || '未填寫';
const className = document.getElementById('class-name').value || '未填寫';
const now = new Date();
const dateStr = now.getFullYear() + '年' + (now.getMonth() + 1) + '月' + now.getDate() + '日';
const timeStr = now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0');

document.getElementById('print-name').innerText = studentName;
document.getElementById('print-class').innerText = className;
document.getElementById('print-count').innerText = count;
document.getElementById('print-date').innerText = dateStr;
document.getElementById('print-total').innerText = total;
document.getElementById('print-average').innerText = average;
document.getElementById('print-time').innerText = dateStr + ' ' + timeStr;

// 填充評語
let comment = "";
if (average >= 95) comment = "👑 太神了！這是頂尖高手的境界！";
else if (average >= 90) comment = "🔥 表現非常優異，繼續保持！";
else if (average >= 80) comment = "👍 很不錯喔！代表實力很紮實！";
else if (average >= 60) comment = "✨ 及格了，繼續努力往前衝！";
else comment = "💪 這次不小心手滑了，下次一定能贏回來！";

document.getElementById('print-comment-box').innerText = comment;

// 顯示成績單並列印
document.getElementById('print-card').classList.add('show');
setTimeout(() => {
window.print();
}, 100);
}
</script>

</body>
</html>
