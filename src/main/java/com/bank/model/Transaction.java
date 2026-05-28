package com.bank.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Transaction {
    private int txnId;
    private String fromAccount;
    private String toAccount;
    private String txnType;        // DEPOSIT | WITHDRAWAL | TRANSFER | INTEREST
    private BigDecimal amount;
    private BigDecimal balanceAfter;
    private String description;
    private Timestamp txnDate;
    private String status;         // SUCCESS | FAILED | PENDING

    public Transaction() {}

    // ---- getters / setters ----
    public int getTxnId()                   { return txnId; }
    public void setTxnId(int v)             { txnId = v; }
    public String getFromAccount()          { return fromAccount; }
    public void setFromAccount(String v)    { fromAccount = v; }
    public String getToAccount()            { return toAccount; }
    public void setToAccount(String v)      { toAccount = v; }
    public String getTxnType()              { return txnType; }
    public void setTxnType(String v)        { txnType = v; }
    public BigDecimal getAmount()           { return amount; }
    public void setAmount(BigDecimal v)     { amount = v; }
    public BigDecimal getBalanceAfter()     { return balanceAfter; }
    public void setBalanceAfter(BigDecimal v){ balanceAfter = v; }
    public String getDescription()          { return description; }
    public void setDescription(String v)    { description = v; }
    public Timestamp getTxnDate()           { return txnDate; }
    public void setTxnDate(Timestamp v)     { txnDate = v; }
    public String getStatus()              { return status; }
    public void setStatus(String v)        { status = v; }
}
