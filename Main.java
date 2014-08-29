// package junior.databases.homework;
package junior.databases.orm;

// import junior.databases.homework.*;
import junior.databases.orm.*;
import java.sql.*;

public class Main {
    private static Connection connection = null;

    public static void main(String[] args) throws SQLException, ClassNotFoundException {
        initDatabase();

        Entity.setDatabase(connection);

    }

    private static void initDatabase() throws SQLException, ClassNotFoundException {
        Class.forName("org.postgresql.Driver");

        connection = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/shop", "postgres",
                    "postgres");
    }
}
