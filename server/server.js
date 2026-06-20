// AI疤痕面诊 - 咨询API服务器
const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

// 存储咨询记录
const DATA_FILE = path.join(__dirname, 'consultations.json');

function loadConsultations() {
  try {
    if (fs.existsSync(DATA_FILE)) {
      return JSON.parse(fs.readFileSync(DATA_FILE, 'utf8'));
    }
  } catch (e) {}
  return [];
}

function saveConsultations(data) {
  fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2), 'utf8');
}

// API: 提交咨询
app.post('/api/consult', (req, res) => {
  const { name, phone, msg, source } = req.body;
  
  if (!name || !phone) {
    return res.status(400).json({ success: false, message: '请填写姓名和联系方式' });
  }

  const consult = {
    id: Date.now().toString(36) + Math.random().toString(36).slice(2, 6),
    name,
    phone,
    msg: msg || '',
    source: source || 'web',
    createdAt: new Date().toISOString(),
    ip: req.ip || req.connection?.remoteAddress || '',
    userAgent: req.headers['user-agent'] || ''
  };

  const consultations = loadConsultations();
  consultations.unshift(consult);
  saveConsultations(consultations);

  console.log(`\n[新咨询] ${consult.createdAt}`);
  console.log(`  称呼: ${consult.name}`);
  console.log(`  联系方式: ${consult.phone}`);
  if (consult.msg) console.log(`  描述: ${consult.msg}`);

  res.json({ success: true, message: '提交成功，咨询师会尽快联系你', id: consult.id });
});

// API: 获取咨询列表 (需要鉴权)
app.get('/api/consults', (req, res) => {
  const token = req.query.token || req.headers['x-admin-token'];
  if (token !== 'yunge-admin-2024') {
    return res.status(401).json({ success: false, message: 'Unauthorized' });
  }
  const consultations = loadConsultations();
  res.json({ success: true, data: consultations, total: consultations.length });
});

// 静态文件服务 (生产环境)
app.use(express.static(path.join(__dirname, '..')));

app.listen(PORT, () => {
  console.log(`✅ AI疤痕面诊 咨询服务器已启动`);
  console.log(`   API: http://localhost:${PORT}/api/consult`);
  console.log(`   后台: http://localhost:${PORT}/api/consults?token=yunge-admin-2024`);
  console.log(`   前端: http://localhost:${PORT}`);
});
