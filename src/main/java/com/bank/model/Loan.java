package com.bank.model;

import java.math.BigDecimal;
import java.sql.Date;

public class Loan {
    private int loanId;
    private int userId;
    private String applicantName;    // joined
    private String loanType;         // HOME | PERSONAL | VEHICLE | EDUCATION
    private BigDecimal principal;
    private BigDecimal interestRate;
    private int tenureMonths;
    private BigDecimal emi;
    private String status;           // PENDING | APPROVED | REJECTED | CLOSED
    private Date appliedDate;
    private Date approvedDate;

    public Loan() {}

    // ---- getters / setters ----
    public int getLoanId()                  { return loanId; }
    public void setLoanId(int v)            { loanId = v; }
    public int getUserId()                  { return userId; }
    public void setUserId(int v)            { userId = v; }
    public String getApplicantName()        { return applicantName; }
    public void setApplicantName(String v)  { applicantName = v; }
    public String getLoanType()             { return loanType; }
    public void setLoanType(String v)       { loanType = v; }
    public BigDecimal getPrincipal()        { return principal; }
    public void setPrincipal(BigDecimal v)  { principal = v; }
    public BigDecimal getInterestRate()     { return interestRate; }
    public void setInterestRate(BigDecimal v){ interestRate = v; }
    public int getTenureMonths()            { return tenureMonths; }
    public void setTenureMonths(int v)      { tenureMonths = v; }
    public BigDecimal getEmi()              { return emi; }
    public void setEmi(BigDecimal v)        { emi = v; }
    public String getStatus()              { return status; }
    public void setStatus(String v)        { status = v; }
    public Date getAppliedDate()           { return appliedDate; }
    public void setAppliedDate(Date v)     { appliedDate = v; }
    public Date getApprovedDate()          { return approvedDate; }
    public void setApprovedDate(Date v)    { approvedDate = v; }
}
