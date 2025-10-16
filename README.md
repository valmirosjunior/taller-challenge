# Taller Challenge - Library API

Simple REST API to manage users, books and reservations for a library.

## How to run

### Prerequisites
- Docker and Docker Compose

### Start the application
```bash
git clone https://github.com/valmirosjunior/taller-challenge.git
cd taller-challenge

# Start everything with Docker
docker compose up --build -d
```

The API will be available at: http://localhost:3000

### Run tests
```bash
# All tests
docker compose exec web bundle exec rspec

# Single file
docker compose exec web bundle exec rspec spec/requests/user_spec.rb
```

### Check code with RuboCop
```bash
# Check code style
docker compose exec web bundle exec rubocop

# Auto-fix issues
docker compose exec web bundle exec rubocop -A
```

### Useful commands
```bash
# View logs
docker compose logs web

# Enter container
docker compose exec web bash

# Stop everything
docker compose down
```

## API

### Users

**List users**
```bash
curl http://localhost:3000/users
```
```json
[{"id": 1, "email": "user@example.com"}]
```

**Get user by ID**
```bash
curl http://localhost:3000/users/1
```
```json
{"id": 1, "email": "user@example.com"}
```

**Create user**
```bash
curl -X POST http://localhost:3000/users \
  -H "Content-Type: application/json" \
  -d '{"email": "new@example.com"}'
```

### Books

**List books**
```bash
curl http://localhost:3000/books
```
```json
[{
  "id": 1,
  "title": "1984",
  "status": "available"
},
{
  "id": 2,
  "title": "The Great Gatsby",
  "status": "reserved"
}]
```

**Get book by ID**
```bash
curl http://localhost:3000/books/1
```
```json
{
  "id": 1,
  "title": "1984",
  "status": "available"
}
```

**Create book**
```bash
curl -X POST http://localhost:3000/books \
  -H "Content-Type: application/json" \
  -d '{
    "title": "New Book"
  }'
```

**Response:**
```json
{
  "id": 3,
  "title": "New Book",
  "status": "available"
}
```

### Reservations

**View book reservations**
```bash
curl http://localhost:3000/books/1/reservations
```

**Get specific reservation**
```bash
curl http://localhost:3000/books/1/reservations/1
```

**Make reservation**
```bash
curl -X POST http://localhost:3000/books/1/reserve \
  -H "Content-Type: application/json" \
  -d '{"user_email": "new@example.com"}'
```

## Technologies

- Ruby on Rails 8.0
- PostgreSQL
- Docker
- RSpec for testing
- RuboCop for code quality
- GitHub Actions for CI/CD
