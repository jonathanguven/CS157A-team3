package com.grocerygander.model;
public class Seller{
    private int idseller;
    private int userId;
    private String isApproved;

    // Constructors
    public Seller() {}

    public Seller(int idseller, int userId, String isApproved) {
        this.idseller = idseller;
        this.userId = userId;
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

    public String getIsApproved() {
        return isApproved;
    }

    public void setIsApproved(String isApproved) {
        this.isApproved = isApproved;
    }
}

