# Student Backend Documentation

## Overview

This is the student backend module for the my_app application. It provides comprehensive APIs for managing student profiles, including CRUD operations and filtering by class.

## Architecture

### Model: Student

Located at: `src/models/student.js`

**Fields:**
- `userId` (ObjectId, required): Reference to the User model
- `firstName` (String, required): Student's first name
- `lastName` (String, required): Student's last name
- `email` (String, required, unique): Student's email address
- `phone` (String): Student's phone number
- `address` (String): Student's residential address
- `birthDate` (Date): Student's date of birth
- `photoUrl` (String): URL to student's profile photo
- `studentClass` (ObjectId, required): Reference to the Class model
- `matricule` (String, required, unique): Student's matriculation number
- `enrollmentDate` (Date): Date of enrollment
- `isActive` (Boolean): Student's active status (soft delete flag)
- `timestamps`: Auto-generated createdAt and updatedAt fields

**Indexes:**
- email, matricule, studentClass, userId for optimized queries

### Controller: Students

Located at: `src/controllers/students.controller.js`

**Methods:**
- `getStudents()`: Retrieve all students with optional filtering
- `getStudentById()`: Get a single student by ID
- `getStudentsByClass()`: Get all students in a specific class
- `createStudent()`: Create a new student profile
- `updateStudent()`: Update student information
- `deleteStudent()`: Soft delete a student (mark as inactive)
- `getStudentProfile()`: Get complete student profile with relations

### Routes: Students

Located at: `src/routes/students.routes.js`

## API Endpoints

### 1. Get All Students
```
GET /api/students
```
**Query Parameters:**
- `classId` (optional): Filter students by class ID
- `isActive` (optional): Filter by active status (true/false)

**Response:**
```json
[
  {
    "_id": "...",
    "userId": {...},
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com",
    "phone": "+212...",
    "address": "123 Street",
    "birthDate": "2000-01-01",
    "photoUrl": null,
    "studentClass": {...},
    "matricule": "STU001",
    "enrollmentDate": "2024-01-15",
    "isActive": true,
    "createdAt": "...",
    "updatedAt": "..."
  }
]
```

### 2. Get Student by ID
```
GET /api/students/:id
```
**Parameters:**
- `id`: Student's MongoDB ObjectId

**Response:** Single student object (same structure as above)

### 3. Get Students by Class
```
GET /api/students/class/:classId
```
**Parameters:**
- `classId`: Class's MongoDB ObjectId

**Response:** Array of students in the specified class

### 4. Create Student
```
POST /api/students
```
**Request Body:**
```json
{
  "userId": "user_id",
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",
  "phone": "+212600000000",
  "address": "123 Street",
  "birthDate": "2000-01-01T00:00:00Z",
  "photoUrl": "https://example.com/photo.jpg",
  "studentClass": "class_id",
  "matricule": "STU001"
}
```

**Required Fields:** userId, firstName, lastName, email, studentClass, matricule

**Response:** Created student object with 201 status

### 5. Update Student
```
PUT /api/students/:id
```
**Parameters:**
- `id`: Student's MongoDB ObjectId

**Request Body:** (Only fields to update)
```json
{
  "phone": "+212700000000",
  "address": "New Address",
  "photoUrl": "https://example.com/new-photo.jpg"
}
```

**Protected Fields** (cannot be modified via this endpoint):
- matricule
- studentClass
- userId

**Response:** Updated student object

### 6. Delete Student (Soft Delete)
```
DELETE /api/students/:id
```
**Parameters:**
- `id`: Student's MongoDB ObjectId

**Response:**
```json
{
  "message": "Student deactivated successfully",
  "student": {...}
}
```

## Integration with Frontend

### Flutter/Dart Integration

Example service call from your Flutter app:

```dart
// Get student profile
Future<Student> getStudentProfile(String studentId) async {
  final response = await http.get(
    Uri.parse('http://your_api:5000/api/students/$studentId'),
  );
  
  if (response.statusCode == 200) {
    return Student.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load student');
  }
}

// Update student profile
Future<void> updateStudentProfile(String studentId, Map<String, dynamic> data) async {
  final response = await http.put(
    Uri.parse('http://your_api:5000/api/students/$studentId'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );
  
  if (response.statusCode != 200) {
    throw Exception('Failed to update student');
  }
}
```

## Error Handling

All endpoints return appropriate HTTP status codes:

- `200 OK`: Successful GET/PUT/DELETE
- `201 Created`: Successful POST
- `400 Bad Request`: Missing required fields or validation error
- `404 Not Found`: Student not found
- `500 Internal Server Error`: Server error

**Error Response Format:**
```json
{
  "message": "Error description"
}
```

## Data Validation

The Student model enforces:
- Unique email addresses
- Unique matricule numbers
- Required fields validation
- Proper data types

## Security Considerations

1. **Protected Fields**: Certain fields (matricule, studentClass, userId) cannot be modified via the update endpoint
2. **Soft Delete**: Students are marked inactive rather than permanently deleted
3. **Population Control**: Sensitive data is limited when populating references

## Future Enhancements

- [ ] Add authentication/authorization middleware
- [ ] Add file upload support for student photos
- [ ] Add pagination for large result sets
- [ ] Add search functionality
- [ ] Add batch operations (bulk create/update)
- [ ] Add audit logging
- [ ] Add data export (CSV, Excel)
