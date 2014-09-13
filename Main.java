package junior.databases.homework;
// package junior.databases.orm;

import junior.databases.homework.*;
// import junior.databases.orm.*;
import java.sql.*;

public class Main {
    private static Connection connection = null;

    public static void main(String[] args) throws SQLException, ClassNotFoundException {
        initDatabase();
        Entity.setDatabase(connection);

        // Section section1 = new Section(1);
        // Post post1 = new Post(1);
        Category cat = new Category();
        cat.setTitle("Lisp");
        cat.setSection(1);
        System.out.println(cat.getId());
        cat.save();
        System.out.println(cat.getId());

        // System.out.println(section1.getColumn("title"));
        // System.out.println(post1.getColumn("title"));
        // post1.setTitle("Very interesting content");
        // post1.save();
        // System.out.println(post1.getColumn("title"));



    }

    private static void initDatabase() throws SQLException, ClassNotFoundException {
        Class.forName("org.postgresql.Driver");

        connection = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/shop", "postgres",
                    "postgres");
    }
}
