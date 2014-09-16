// package junior.databases.homework;
package junior.databases.orm;

// import junior.databases.homework.*;
import junior.databases.orm.*;
import java.sql.*;

public class Main {
    private static Connection connection = null;

    public static void main(String[] args) throws SQLException, ClassNotFoundException {
        initDatabase();
        Entity.setDatabase(null);        

        Category category = new Category();
        category.setTitle("Newest Category A");
        category.setSection(1);
        System.out.println(category.getId());
        category.save();
        System.out.println(category.getCreated());


        // Section section1 = new Section(1);
        // Post post1 = new Post(1);
        // for (Tag c : Tag.all(Tag.class)) {
        //     System.out.println(c.getId() + " | " + c.getName() + " | " + c.getCreated());
        // }

        // Tag t = new Tag();
        // t.setName("NewSuperTag");
        // t.save();

    }

    private static void initDatabase() throws SQLException, ClassNotFoundException {
        Class.forName("org.postgresql.Driver");

        connection = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/shop", "postgres",
                    "postgres");
    }
}
