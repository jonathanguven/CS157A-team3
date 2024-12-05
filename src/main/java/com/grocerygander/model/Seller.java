package com.grocerygander.model;
public class Seller{
    private int idseller;
    private int userId;
    private String email;
    private String isApproved;

    // Constructors
    public Seller() {}

    public Seller(int idseller, int userId, String email, String isApproved) {
        this.idseller = idseller;
        this.userId = userId;
        this.email = email;
        this.isApproved = isApproved;
    }

    // Getters and setters
    public int getIdseller() {
        return idseller;
    }

    public void setIdseller(int idseller) {
        this.idseller = idseller;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getEmail() {
    	return email;
    }
    
    public void setEmail(String email) {
    	this.email = email;
    }

    public String getIsApproved() {
        return isApproved;
    }

    public void setIsApproved(String isApproved) {
        this.isApproved = isApproved;
    }
}

