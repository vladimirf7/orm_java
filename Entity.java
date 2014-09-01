// package junior.databases.homework;
package junior.databases.orm;

import java.util.*;
import java.sql.*;
import java.lang.reflect.Constructor;
import java.text.SimpleDateFormat;

public abstract class Entity {
    private static String DELETE_QUERY   = "DELETE FROM \"%1$s\" WHERE %1$s_id=?";
    private static String INSERT_QUERY   = "INSERT INTO \"%1$s\" (%2$s) VALUES (%3$s) RETURNING %1$s_id";
    private static String LIST_QUERY     = "SELECT * FROM \"%s\"";
    private static String SELECT_QUERY   = "SELECT * FROM \"%1$s\" WHERE %1$s_id=?";
    private static String CHILDREN_QUERY = "SELECT * FROM \"%1$s\" WHERE %2$s_id=?";
    private static String SIBLINGS_QUERY = "SELECT * FROM \"%1$s\" NATURAL JOIN \"%2$s\" WHERE %3$s_id=?";
    private static String UPDATE_QUERY   = "UPDATE \"%1$s\" SET %2$s WHERE %1$s_id=?";

    private static Connection db = null;

    protected boolean isLoaded = false;
    protected boolean isModified = false;
    private String table = null;
    private int id = 0;
    protected Map<String, Object> fields = new HashMap<String, Object>();

    public Entity() {
        this(0);
    }

    public Entity(Integer id) {
        this.id = id;
        table = this.getClass().getSimpleName().toLowerCase();        
    }

    public static final void setDatabase(Connection connection) {
        db = connection;
    }

    public final int getId() {
        return this.id;
    }

    public final java.util.Date getCreated() {
        return getDate("_created");
    }

    public final java.util.Date getUpdated() {
        return getDate("_updated");
    }

    public final Object getColumn(String name) {
        load();
        return fields.get(table + "_" + name);
    }

    // public final <T extends Entity> T getParent(Class<T> cls) {
    //     T result = null;
    //     int id = (int) fields.get(cls.getSimpleName().toLowerCase() + "_id");

    //     try {
    //         Constructor<?> constructor = cls.getConstructor();
    //         result = (T) constructor.newInstance(id);
    //     } catch (Exception ex) {}

    //     return result;
    // }

    // public final <T extends Entity> List<T> getChildren(Class<T> cls) {
    //     List<T> result = new ArrayList<T>();
    //     String childClass = cls.getSimpleName().toLowerCase();

    //     try {
    //         String query = String.format(CHILDREN_QUERY, table, childClass);            
    //         PreparedStatement stmt = db.prepareStatement(query);
    //         stmt.setString(1, childClass);
    //         ResultSet rs = stmt.executeQuery();
    //         ResultSetMetaData rsmd = rs.getMetaData();

    //         while (rs.next()) {
    //             int numColumns = rs.getMetaData().getColumnCount();
    //             System.out.println("DEBUG: " + numColumns);

    //             for (int i = 1; i <= numColumns; i++) {
    //                 String name = rsmd.getColumnName(i);
    //                 Object value = rs.getObject(i);

    //                 fields.put(name, value);
    //                 System.out.println("DEBUG: " + name + " " + value);
    //             }
    //         }
    //     } catch (Exception ex) {
    //         ex.printStackTrace();
    //     }

    //     return result;
    // }

    // public final <T extends Entity> List<T> getSiblings(Class<T> cls) {
    //     // select needed rows and ALL columns from corresponding table
    //     // convert each row from ResultSet to instance of class T with appropriate id
    //     // fill each of new instances with column data
    //     // return list of sibling instances
    // }

    public final void setColumn(String name, Object value) {
        fields.put(table + "_" + name, value);
    }

    public final void setParent(String name, Integer id) {
        fields.put(name + "_id", id);
    }

    private void load() {
        if (isLoaded) return;
        try {
            String query = String.format(SELECT_QUERY, table);            
            PreparedStatement stmt = db.prepareStatement(query);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();

            while (rs.next()) {
                int numColumns = rs.getMetaData().getColumnCount();
                // System.out.println("DEBUG: " + numColumns);

                for (int i = 1; i <= numColumns; i++) {
                    String name = rsmd.getColumnName(i);
                    Object value = rs.getObject(i);

                    fields.put(name, value);                    
                    // System.out.println("DEBUG: " + name + " " + value);
                }
                isLoaded = true;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void insert() throws SQLException {
        // execute an insert query, built from fields keys and values
        // "INSERT INTO \"%1$s\" (%2$s) VALUES (%3$s) RETURNING %1$s_id";
        String fieldNames = new String();
        String fieldValues = new String();

        for (Map.Entry<String, Object> entry : fields.entrySet()) {
            fieldNames += entry.getKey() + ", ";
            fieldValues += "'" + entry.getValue() + "', ";
        }
        fieldNames = fieldNames.substring(0, fieldNames.length() - 2);
        fieldValues = fieldValues.substring(0, fieldValues.length() - 2);
        String query = String.format(INSERT_QUERY, table, fieldNames, fieldValues);
        PreparedStatement stmt = db.prepareStatement(query);
        // System.out.println("DEBUG insert(): " + stmt);
        try {
            ResultSet rs = stmt.executeQuery();
            int id = rs.getInt(table + "_id");
            System.out.println("DEBUG id: " + id);
            this.id = id;
        } catch (SQLException ex) {}        
    }

    private void update() throws SQLException {
        try {
            for (Map.Entry<String, Object> entry : fields.entrySet()) {
                String name = entry.getKey();
                Object value = entry.getValue();
                String setStr = name + " = '" + value + "'";
                String query = String.format(UPDATE_QUERY, table, setStr);
                PreparedStatement stmt = db.prepareStatement(query);
                System.out.println("DEBUG 1: " + setStr);
                stmt.setInt(1, this.id);
                stmt.executeUpdate();   
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    // public final void delete() throws SQLException {
    //     // execute a delete query with current instance id
    // }

    public final void save() throws SQLException {
        // execute either insert or update query, depending on instance id
        if (id == 0) {
            insert();
        } else {
            update();
        }
        
    }

    protected static <T extends Entity> List<T> all(Class<T> cls) {
        List<T> result = new ArrayList<T>();
        String table = cls.getSimpleName().toLowerCase();

        String query = String.format(LIST_QUERY, table);
        try {
            Statement stmt = db.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            while (rs.next()) {
                int id = (int) rs.getObject(table + "_id");
                T obj = (T) cls.getConstructor().newInstance(id);
                result.add(obj);
            }        
        } catch (Exception ex) {}

        return result;
    }

    // private static Collection<String> genPlaceholders(int size) {
    //     // return a string, consisting of <size> "?" symbols, joined with ", "
    //     // each "?" is used in insert statements as a placeholder for values (google prepared statements)
    // }

    // private static Collection<String> genPlaceholders(int size, String placeholder) {
    //     // return a string, consisting of <size> <placeholder> symbols, joined with ", "
    //     // each <placeholder> is used in insert statements as a placeholder for values (google prepared statements)
    // }

    // private static String getJoinTableName(String leftTable, String rightTable) {
    //     // generate the name of associative table for many-to-many relation
    //     // sort left and right tables alphabetically
    //     // return table name using format <table>__<table>
    // }

    private java.util.Date getDate(String column) {
        String strDate = (String) fields.get(table + column);
        java.util.Date date = null;
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        // 2014-08-29 16:20:41.032

        if (strDate != null && !strDate.isEmpty()) {
            try {
                date = formatter.parse(strDate);
            } catch (Exception e) {}
        }
        return date;
    }

    // private static String join(Collection<String> sequence) {
    //     // join collection of strings with ", " as glue and return a joined string
    // }

    // private static String join(Collection<String> sequence, String glue) {
    //     // join collection of strings with glue and return a joined string
    // }

    // private static <T extends Entity> List<T> rowsToEntities(Class<T> cls, ResultSet rows) {
    //     // convert a ResultSet of database rows to list of instances of corresponding class
    //     // each instance must be filled with its data so that it must not produce additional queries to database to get it's fields
    // }
}
