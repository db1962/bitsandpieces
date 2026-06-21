Exaple of converting SQL to POCO class

Sample based off copilot.

```csharp
using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;

class PocoGenerator
{
    static void Main()
    {
        string connectionString = "Server=.;Database=YourDb;Trusted_Connection=True;";
        string sql = @"
            SELECT Id, Name, CreatedDate, IsActive
            FROM Users";

        string className = "UserDto";

        string result = GeneratePoco(connectionString, sql, className);
        Console.WriteLine(result);
    }

    public static string GeneratePoco(string connectionString, string query, string className)
    {
        using (var conn = new SqlConnection(connectionString))
        using (var cmd = new SqlCommand(query, conn))
        {
            conn.Open();

            using (var reader = cmd.ExecuteReader(CommandBehavior.SchemaOnly))
            {
                var schema = reader.GetSchemaTable();
                var sb = new StringBuilder();

                sb.AppendLine($"public class {className}");
                sb.AppendLine("{");

                foreach (DataRow row in schema.Rows)
                {
                    string columnName = row["ColumnName"].ToString();
                    Type dataType = (Type)row["DataType"];
                    bool isNullable = (bool)row["AllowDBNull"];

                    string csharpType = MapToCSharpType(dataType, isNullable);

                    sb.AppendLine($"    public {csharpType} {ToPascalCase(columnName)} {{ get; set; }}");
                }

                sb.AppendLine("}");
                return sb.ToString();
            }
        }
    }

    private static string MapToCSharpType(Type type, bool isNullable)
    {
        string result = type.Name switch
        {
            "Int32" => "int",
            "Int64" => "long",
            "String" => "string",
            "DateTime" => "DateTime",
            "Boolean" => "bool",
            "Decimal" => "decimal",
            "Double" => "double",
            "Guid" => "Guid",
            "Byte[]" => "byte[]",
            _ => "object"
        };

        if (result != "string" && result != "byte[]" && isNullable)
        {
            return result + "?";
        }

        return result;
    }

    private static string ToPascalCase(string input)
    {
        if (string.IsNullOrWhiteSpace(input)) return input;

        var parts = input.Split('_', ' ');
        var result = "";

        foreach (var part in parts)
        {
            if (part.Length > 0)
                result += char.ToUpper(part[0]) + part.Substring(1);
        }

        return result;
    }
}
```
