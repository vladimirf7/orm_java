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
        this(null);
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
        if (isModified) load();

        return getDate("_created");
    }

    public final java.util.Date getUpdated() {
        if (isModified) load();
        
        return getDate("_updated");
    }

    public final Object getColumn(String name) {
        load();
        return fields.get(table + "_" + name);
    }    

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

                for (int i = 1; i <= numColumns; i++) {
                    String name = rsmd.getColumnName(i);
                    Object value = rs.getObject(i);

                    fields.put(name, value);                    
                }
                isLoaded = true;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void insert() throws SQLException {
        String fieldNames = new String();
        String fieldValues = new String();
        String query;
        PreparedStatement stmt;
        ResultSet rs;
        int id;

        for (Map.Entry<String, Object> entry : fields.entrySet()) {
            fieldNames += entry.getKey() + ", ";
            fieldValues += "'" + entry.getValue() + "', ";
        }
        fieldNames = fieldNames.substring(0, fieldNames.length() - 2);
        fieldValues = fieldValues.substring(0, fieldValues.length() - 2);
        query = String.format(INSERT_QUERY, table, fieldNames, fieldValues);
        stmt = db.prepareStatement(query);
        rs = stmt.executeQuery();

        while (rs.next()) {
            id = rs.getInt(table + "_id");
            this.id = id;
        }
        isModified = true;
        isLoaded = false;
    }

    private void update() throws SQLException {
        String name;
        Object value;
        String setStr;
        String query;
        PreparedStatement stmt;

        try {
            for (Map.Entry<String, Object> entry : fields.entrySet()) {
                name = entry.getKey();
                value = entry.getValue();
                setStr = name + " = '" + value + "'";
                query = String.format(UPDATE_QUERY, table, setStr);
                stmt = db.prepareStatement(query);
                stmt.setInt(1, this.id);
                stmt.executeUpdate();   
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        isModified = true;
        isLoaded = false;
    }

    public final void delete() throws SQLException {
        if (this.id == 0) throw new RuntimeException("Unable to delete item with id == 0");

        String query = String.format(DELETE_QUERY, table);
        PreparedStatement stmt = db.prepareStatement(query);

        stmt.setInt(1, this.id);
        stmt.executeUpdate();
        this.id = 0;
        isModified = true;
        isLoaded = false;
    }

    public final void save() throws SQLException {
        if (id == 0) {
            insert();
        } else {
            update();
        }
        
    }

    protected static <T extends Entity> List<T> all(Class<T> cls) {
        List<T> result = new ArrayList<T>();
        String table = cls.getSimpleName().toLowerCase();
        Statement stmt;
        ResultSet rs;
        int id;
        T obj;

        String query = String.format(LIST_QUERY, table);
        try {
            stmt = db.createStatement();
            rs = stmt.executeQuery(query);

            while (rs.next()) {
                id = (int) rs.getObject(table + "_id");
                obj = (T) cls.getConstructor(Integer.class).newInstance(id);
                result.add(obj);
            }        
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return result;
    }

    private java.util.Date getDate(String column) {
        int intDate = (int) fields.get(table + column);
        java.util.Date date = null;
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        try {
            date = new java.util.Date(intDate * 1000L);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return date;
    }

}
