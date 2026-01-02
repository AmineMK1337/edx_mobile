const http = require('http');

const BASE_URL = 'localhost';
const PORT = 3000;

function makeRequest(path, token = null) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: BASE_URL,
      port: PORT,
      path: `/api${path}`,
      method: 'GET',
      headers: token ? { 'Authorization': `Bearer ${token}` } : {}
    };

    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => data += chunk);
      res.on('end', () => {
        try {
          resolve(JSON.parse(data));
        } catch (e) {
          reject(e);
        }
      });
    });

    req.on('error', reject);
    req.end();
  });
}

function makePostRequest(path, body) {
  return new Promise((resolve, reject) => {
    const postData = JSON.stringify(body);
    const options = {
      hostname: BASE_URL,
      port: PORT,
      path: `/api${path}`,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': postData.length
      }
    };

    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => data += chunk);
      res.on('end', () => {
        try {
          resolve(JSON.parse(data));
        } catch (e) {
          reject(e);
        }
      });
    });

    req.on('error', reject);
    req.write(postData);
    req.end();
  });
}

async function testAPI() {
  try {
    console.log('🔐 Testing Authentication...');
    const loginRes = await makePostRequest('/auth/login', {
      email: 'admin@example.com',
      password: 'password123'
    });
    
    const token = loginRes.token;
    console.log('✅ Login successful\n');

    // Test new endpoints
    console.log('📚 Testing Classes endpoint...');
    const classes = await makeRequest('/classes', token);
    console.log(`✅ Classes: ${classes.length} found`);
    console.log(`   - ${classes[0].name}: ${classes[0].studentCount} students\n`);

    console.log('📅 Testing Academic Years endpoint...');
    const academicYears = await makeRequest('/academic-years', token);
    console.log(`✅ Academic Years: ${academicYears.length} found`);
    console.log(`   - ${academicYears[0].year} Semester ${academicYears[0].semester}\n`);

    console.log('📝 Testing Enrollments endpoint...');
    const enrollments = await makeRequest('/enrollments', token);
    console.log(`✅ Enrollments: ${enrollments.length} found\n`);

    console.log('📖 Testing Courses endpoint...');
    const courses = await makeRequest('/courses', token);
    console.log(`✅ Courses: ${courses.length} found`);
    if (courses.length > 0) {
      const course = courses[0];
      console.log(`   - ${course.title} (${course.code})`);
      console.log(`     Professor: ${course.professor?.name || 'N/A'}`);
      console.log(`     Class: ${course.class?.name || 'N/A'}`);
      console.log(`     Academic Year: ${course.academicYear?.year || 'N/A'}\n`);
    }

    console.log('📋 Testing Exams endpoint...');
    const exams = await makeRequest('/exams', token);
    console.log(`✅ Exams: ${exams.length} found`);
    if (exams.length > 0) {
      const exam = exams[0];
      console.log(`   - ${exam.title}`);
      console.log(`     Course: ${exam.course?.title || 'N/A'}`);
      console.log(`     Class: ${exam.class?.name || 'N/A'}`);
      console.log(`     Date: ${new Date(exam.date).toLocaleDateString()}\n`);
    }

    console.log('✅ Testing Notes endpoint...');
    const notes = await makeRequest('/notes', token);
    console.log(`✅ Notes: ${notes.length} found`);
    if (notes.length > 0) {
      const note = notes[0];
      console.log(`   - Student: ${note.student?.name || 'N/A'}`);
      console.log(`     Course: ${note.course?.title || 'N/A'}`);
      console.log(`     Type: ${note.type}`);
      console.log(`     Value: ${note.value}/20\n`);
    }

    console.log('🎉 All API endpoints working correctly!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Test failed:', error.message || error);
    process.exit(1);
  }
}

testAPI();
