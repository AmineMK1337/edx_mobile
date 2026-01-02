const axios = require('axios');

const API_URL = 'http://localhost:3000/api';

async function testDocumentsFeature() {
  try {
    console.log('🔐 Testing Documents Feature\n');

    // Step 1: Login as a student
    console.log('1. Logging in as a student...');
    const loginRes = await axios.post(`${API_URL}/auth/login`, {
      email: 'student1@example.com',
      password: 'password123'
    });

    const token = loginRes.data.token;
    console.log('✅ Login successful, token obtained\n');

    const headers = {
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json'
    };

    // Step 2: Get list of courses
    console.log('2. Fetching courses...');
    const coursesRes = await axios.get(`${API_URL}/courses`, { headers });
    const courses = coursesRes.data;
    console.log(`✅ Found ${courses.length} courses\n`);

    if (courses.length === 0) {
      console.log('No courses found, skipping documents test');
      process.exit(0);
    }

    const courseId = courses[0]._id;
    console.log(`3. Fetching documents for course: ${courses[0].title}`);
    console.log(`   Course ID: ${courseId}\n`);

    // Step 3: Get documents for the first course
    const docsRes = await axios.get(`${API_URL}/documents/course/${courseId}`, { headers });
    const documents = docsRes.data;
    console.log(`✅ Found ${documents.length} documents\n`);

    if (documents.length > 0) {
      console.log('Documents:');
      documents.forEach((doc, idx) => {
        console.log(`  ${idx + 1}. ${doc.title}`);
        console.log(`     Type: ${doc.fileType}`);
        console.log(`     Downloads: ${doc.downloads}`);
        console.log(`     Published: ${doc.isPublished}`);
      });
    }

    // Step 4: Try to download a document (increment view count)
    if (documents.length > 0) {
      const docId = documents[0]._id;
      console.log(`\n4. Accessing document: ${documents[0].title}`);
      const docRes = await axios.get(`${API_URL}/documents/${docId}`, { headers });
      console.log(`✅ Document accessed successfully`);
      console.log(`   Downloads: ${docRes.data.downloads}`);
    }

    console.log('\n✅ Documents feature test completed successfully!');
    process.exit(0);

  } catch (error) {
    if (error.response) {
      console.error('❌ Error:', error.response.status, error.response.data);
    } else {
      console.error('❌ Error:', error.message);
    }
    process.exit(1);
  }
}

testDocumentsFeature();
