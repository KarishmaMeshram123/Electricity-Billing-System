import java.sql.*;
import java.util.Scanner;

public class ElectricityBillingSystem {

    // MySQL Connection Details
    static final String URL = "jdbc:mysql://localhost:3306/electricity_billing"; // database name
    static final String USER = "root"; // your MySQL username
    static final String PASS = "karishma@123"; // change to your MySQL password

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        try (Connection conn = DriverManager.getConnection(URL, USER, PASS)) {
            System.out.println("✅ Connected to Database!");

            while (true) {
                System.out.println("\n--- Electricity Billing System ---");
                System.out.println("1. Add Customer");
                System.out.println("2. Generate Bill");
                System.out.println("3. View Bills");
                System.out.println("4. Exit");
                System.out.print("Enter choice: ");
                int choice = sc.nextInt();
                sc.nextLine(); // consume newline

                switch (choice) {
                    case 1 -> addCustomer(conn, sc);
                    case 2 -> generateBill(conn, sc);
                    case 3 -> viewBills(conn);
                    case 4 -> {
                        System.out.println("Exiting...");
                        return;
                    }
                    default -> System.out.println("❌ Invalid choice! Try again.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Add new customer
    static void addCustomer(Connection conn, Scanner sc) throws SQLException {
        System.out.print("Enter Name: ");
        String name = sc.nextLine();
        System.out.print("Enter Address: ");
        String address = sc.nextLine();
        System.out.print("Enter Meter No: ");
        String meterNo = sc.nextLine();

        String sql = "INSERT INTO customers (name, address, meter_no) VALUES (?, ?, ?)";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, name);
        stmt.setString(2, address);
        stmt.setString(3, meterNo);
        stmt.executeUpdate();

        System.out.println("✅ Customer added successfully!");
    }

    // Generate bill for customer
    static void generateBill(Connection conn, Scanner sc) throws SQLException {
        System.out.print("Enter Customer ID: ");
        int customerId = sc.nextInt();
        System.out.print("Enter Units Consumed: ");
        int units = sc.nextInt();

        double ratePerUnit = 7.5; // Example fixed rate
        double totalAmount = units * ratePerUnit;

        String sql = "INSERT INTO bills (customer_id, units_consumed, total_amount, bill_date) VALUES (?, ?, ?, CURDATE())";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, customerId);
        stmt.setInt(2, units);
        stmt.setDouble(3, totalAmount);
        stmt.executeUpdate();

        System.out.println("✅ Bill generated successfully! Amount: " + totalAmount);
    }

    // View all bills
    static void viewBills(Connection conn) throws SQLException {
        String sql = "SELECT b.bill_id, c.name, b.units_consumed, b.total_amount, b.bill_date " +
                "FROM bills b JOIN customers c ON b.customer_id = c.customer_id";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        System.out.println("\n--- Bills ---");
        while (rs.next()) {
            System.out.println("Bill ID: " + rs.getInt("bill_id") +
                    ", Name: " + rs.getString("name") +
                    ", Units: " + rs.getInt("units_consumed") +
                    ", Amount: " + rs.getDouble("total_amount") +
                    ", Date: " + rs.getDate("bill_date"));
        }
    }
}


