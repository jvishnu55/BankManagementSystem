-- ============================================================
--  BANK MANAGEMENT SYSTEM - MySQL Schema
-- ============================================================

CREATE DATABASE IF NOT EXISTS bank_management;
USE bank_management;

-- -------------------------------------------------------
-- 1. USERS (login accounts)
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    user_id     INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,          -- SHA-256 hex
    full_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    phone       VARCHAR(20),
    role        ENUM('ADMIN','CUSTOMER') NOT NULL DEFAULT 'CUSTOMER',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active   BOOLEAN DEFAULT TRUE
);

-- -------------------------------------------------------
-- 2. ACCOUNTS
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS accounts (
    account_id      INT AUTO_INCREMENT PRIMARY KEY,
    account_number  VARCHAR(20) NOT NULL UNIQUE,
    user_id         INT NOT NULL,
    account_type    ENUM('SAVINGS','CURRENT','FIXED_DEPOSIT') NOT NULL DEFAULT 'SAVINGS',
    balance         DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    interest_rate   DECIMAL(5,2) DEFAULT 3.50,
    status          ENUM('ACTIVE','FROZEN','CLOSED') NOT NULL DEFAULT 'ACTIVE',
    opened_date     DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- -------------------------------------------------------
-- 3. TRANSACTIONS
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS transactions (
    txn_id          INT AUTO_INCREMENT PRIMARY KEY,
    from_account    VARCHAR(20),
    to_account      VARCHAR(20),
    txn_type        ENUM('DEPOSIT','WITHDRAWAL','TRANSFER','INTEREST') NOT NULL,
    amount          DECIMAL(15,2) NOT NULL,
    balance_after   DECIMAL(15,2) NOT NULL,
    description     VARCHAR(255),
    txn_date        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status          ENUM('SUCCESS','FAILED','PENDING') DEFAULT 'SUCCESS'
);

-- -------------------------------------------------------
-- 4. LOANS
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS loans (
    loan_id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT NOT NULL,
    loan_type       ENUM('HOME','PERSONAL','VEHICLE','EDUCATION') NOT NULL,
    principal       DECIMAL(15,2) NOT NULL,
    interest_rate   DECIMAL(5,2) NOT NULL,
    tenure_months   INT NOT NULL,
    emi             DECIMAL(12,2) NOT NULL,
    status          ENUM('PENDING','APPROVED','REJECTED','CLOSED') DEFAULT 'PENDING',
    applied_date    DATE NOT NULL,
    approved_date   DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- -------------------------------------------------------
-- 5. SEED DATA
-- -------------------------------------------------------

-- Admin user  (password = "admin123" SHA-256)
INSERT INTO users (username, password, full_name, email, phone, role) VALUES
('admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',
 'System Administrator', 'admin@bankms.com', '9000000001', 'ADMIN');

-- Sample customers  (password = "pass1234" SHA-256)
INSERT INTO users (username, password, full_name, email, phone, role) VALUES
('john_doe',  '6e6b0d0f6a00e7e8b66df5d3ce6cbe01e1c1a6394b7e15a63a4a4fb47f58f5b6',
 'John Doe',  'john@example.com', '9000000002', 'CUSTOMER'),
('jane_smith','6e6b0d0f6a00e7e8b66df5d3ce6cbe01e1c1a6394b7e15a63a4a4fb47f58f5b6',
 'Jane Smith','jane@example.com', '9000000003', 'CUSTOMER');

-- Sample accounts
INSERT INTO accounts (account_number, user_id, account_type, balance, opened_date) VALUES
('ACC1000000001', 2, 'SAVINGS', 25000.00, CURDATE()),
('ACC1000000002', 3, 'CURRENT', 75000.00, CURDATE()),
('ACC1000000003', 3, 'SAVINGS',  5000.00, CURDATE());

-- Sample transactions
INSERT INTO transactions (from_account, to_account, txn_type, amount, balance_after, description) VALUES
(NULL, 'ACC1000000001', 'DEPOSIT',    25000.00, 25000.00, 'Initial deposit'),
(NULL, 'ACC1000000002', 'DEPOSIT',    75000.00, 75000.00, 'Initial deposit'),
(NULL, 'ACC1000000003', 'DEPOSIT',     5000.00,  5000.00, 'Initial deposit'),
('ACC1000000002','ACC1000000001','TRANSFER', 2000.00, 73000.00, 'Fund transfer');

-- Sample loan
INSERT INTO loans (user_id, loan_type, principal, interest_rate, tenure_months, emi, status, applied_date) VALUES
(2, 'PERSONAL', 50000.00, 10.5, 24, 2307.50, 'APPROVED', CURDATE());
