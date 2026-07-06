SELECT
    pt.name AS parent_table,
    pc.name AS parent_column,
    ct.name AS child_table,
    cc.name AS child_column
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc
    ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.tables pt
    ON fkc.referenced_object_id = pt.object_id
INNER JOIN sys.columns pc
    ON fkc.referenced_object_id = pc.object_id
    AND fkc.referenced_column_id = pc.column_id
INNER JOIN sys.tables ct
    ON fkc.parent_object_id = ct.object_id
INNER JOIN sys.columns cc
    ON fkc.parent_object_id = cc.object_id
    AND fkc.parent_column_id = cc.column_id
ORDER BY
    pt.name,
    ct.name,
    pc.column_id;
