public class SellerRequest {
    private int sellerId;
    private int userId;
    private String username;
    private String isApproved;

    public SellerRequest(int sellerId, int userId, String username, String isApproved) {
        this.sellerId = sellerId;
        this.userId = userId;
        this.username = username;
        this.isApproved = isApproved;
    }

    // Getters and setters
    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getIsApproved() { return isApproved; }
    public void setIsApproved(String isApproved) { this.isApproved = isApproved; }
}
