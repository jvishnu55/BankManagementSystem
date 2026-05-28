# 🏦 Bank Management System
**Full-Stack Java Web Application**

A complete banking system built with Java Servlets + JSP (backend), MySQL (database), and a custom premium HTML/CSS frontend.

---

## ✨ Features

### Customer Portal
- 🔐 Secure login & registration
- 💳 Open multiple accounts (Savings, Current, Fixed Deposit)
- 💰 Deposit & Withdraw funds
- ↔️ Transfer funds to any account
- 📋 View complete transaction history
- 🏠 Apply for loans (Personal, Home, Vehicle, Education)
- 📊 Personal dashboard with balance overview

### Admin Portal
- 📊 System-wide stats dashboard
- 👥 Manage all customers (activate/deactivate)
- 💳 View & manage all accounts (freeze/activate)
- 📝 Approve or reject loan applications
- 📋 View all transactions system-wide

---

## 🛠️ Tech Stack

| Layer      | Technology                        |
|------------|-----------------------------------|
| Frontend   | HTML5, CSS3, JavaScript (vanilla) |
| Backend    | Java 11, Servlets 4.0, JSP 2.3   |
| Database   | MySQL 8.x                         |
| Build      | Maven 3.x                         |
| Server     | Apache Tomcat 9.x                 |
| Security   | SHA-256 password hashing          |

---

## 📁 Project Structure

```
BankManagementSystem/
├── pom.xml
├── sql/
│   └── bank_schema.sql               ← Run this first!
└── src/main/
    ├── java/com/bank/
    │   ├── model/                    ← User, Account, Transaction, Loan
    │   ├── dao/                      ← UserDAO, AccountDAO, TransactionDAO, LoanDAO
    │   ├── servlet/                  ← All HTTP Servlets
    │   └── util/                     ← DBConnection, PasswordUtil
    └── webapp/
        ├── WEB-INF/web.xml
        ├── css/style.css
        ├── index.jsp
        └── pages/
            ├── login.jsp
            ├── register.jsp
            ├── customer-dashboard.jsp
            └── admin-dashboard.jsp
```

---

## ⚡ Setup Instructions

### Prerequisites
- Java 11+
- Maven 3.6+
- MySQL 8.x
- Apache Tomcat 9.x (or use embedded via Maven)

### Step 1 — Database Setup
```sql
-- Open MySQL and run:
mysql -u root -p < sql/bank_schema.sql
```

### Step 2 — Configure DB Connection
Edit `src/main/java/com/bank/util/DBConnection.java`:
```java
private static final String DB_URL  = "jdbc:mysql://localhost:3306/bank_management";
private static final String DB_USER = "root";
private static final String DB_PASS = "your_mysql_password";   // ← change this
```

### Step 3 — Build
```bash
mvn clean package
```
This creates `target/BankManagementSystem.war`

### Step 4A — Deploy to Tomcat
Copy the WAR to Tomcat's `webapps/` folder:
```bash
cp target/BankManagementSystem.war /path/to/tomcat/webapps/
```

### Step 4B — Run with Maven (Easier)
```bash
mvn tomcat7:run
```
Then open: **http://localhost:8080/bank**

---

## 🔑 Demo Credentials

| Role     | Username   | Password  |
|----------|------------|-----------|
| Admin    | `admin`    | `admin123`|
| Customer | `john_doe` | `pass1234`|
| Customer | `jane_smith`| `pass1234`|

---

## 🗃️ Database Schema

```
users          → id, username, password(SHA256), full_name, email, phone, role, is_active
accounts       → id, account_number, user_id(FK), type, balance, interest_rate, status, opened_date
transactions   → id, from_account, to_account, type, amount, balance_after, description, date, status
loans          → id, user_id(FK), type, principal, interest_rate, tenure_months, emi, status, dates
```

---

## 🌐 URL Mapping

| URL                        | Description             |
|----------------------------|-------------------------|
| `/`                        | Redirects to login      |
| `/login`                   | Login page (GET/POST)   |
| `/register`                | Registration (GET/POST) |
| `/logout`                  | Logout                  |
| `/customer/dashboard`      | Customer portal         |
| `/admin/dashboard`         | Admin portal            |
| `/admin/action`            | Admin operations (POST) |

---

## 🔒 Security Features
- Passwords hashed with SHA-256 before storing
- Session-based authentication (30-min timeout)
- Role-based access control (ADMIN vs CUSTOMER)
- SQL injection prevention via PreparedStatements
- ACID-compliant fund transfers (DB transactions with rollback)

---

## 📈 EMI Calculation
Uses standard reducing balance formula:
```
EMI = P × r × (1+r)^n / ((1+r)^n − 1)
where r = monthly interest rate, n = tenure in months
```
