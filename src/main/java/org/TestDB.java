package org;

import java.sql.Connection;

public class TestDB {
    public static void main(String[] args) {
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            System.out.println("Connection test successful!");
            DBConnection.closeConnection(conn);
        } else {
            System.out.println("Connection test failed.");
        }
    }
}