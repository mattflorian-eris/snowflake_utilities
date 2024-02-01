/***************************************************************************************************
Procedure:          dbo.usp_DoSomeStuff
Create Date:        2018-01-25
Author:             Joe Expert
Description:        Verbose description of what the query does goes here. Be specific and don't be
                    afraid to say too much. More is better, than less, every single time. Think about
                    "what, when, where, how and why" when authoring a description.
Call by:            [schema.usp_ProcThatCallsThis]
                    [Application Name]
                    [Job]
                    [PLC/Interface]
Affected table(s):  [schema.TableModifiedByProc1]
                    [schema.TableModifiedByProc2]
Used By:            Functional Area this is use in, for example, Payroll, Accounting, Finance
Parameter(s):       @param1 - description and usage
                    @param2 - description and usage
Usage:              EXEC dbo.usp_DoSomeStuff
                        @param1 = 1,
                        @param2 = 3,
                        @param3 = 2
                    Additional notes or caveats about this object, like where is can and cannot be run, or
                    gotchas to watch for when using it.
****************************************************************************************************
SUMMARY OF CHANGES
Date(yyyy-mm-dd)    Author              Comments
------------------- ------------------- ------------------------------------------------------------
2012-04-27          John Usdaworkhur    Move Z <-> X was done in a single step. Warehouse does not
                                        allow this. Converted to two step process.
                                        Z <-> 7 <-> X
                                            1) move class Z to class 7
                                            2) move class 7 to class X

2018-03-22          Maan Widaplan       General formatting and added header information.
2018-03-22          Maan Widaplan       Added logic to automatically Move G <-> H after 12 months.
***************************************************************************************************/


CREATE OR REPLACE PROCEDURE GRANT_DB_USAGE_ACCT_ADMIN_READONLY()
RETURNS table() NOT NULL
LANGUAGE SQL
AS
$$
DECLARE
  rs RESULTSET;
  query_id VARCHAR;
BEGIN
  --SELECT 1 AS col1, 'a' AS col2;
  SHOW DATABASES;
  
  query_id := (SELECT last_query_id());
  
  let sql VARCHAR := 'select "name" as name from table(result_scan(''' || query_id || ''')) WHERE "kind" = ''STANDARD'' ' ;
 
  LET db_names RESULTSET := (EXECUTE IMMEDIATE :sql);

  LET cur CURSOR FOR db_names;
  FOR row_variable IN cur DO
  --
  -- GRANT USAGE ON DATABASE
  --
    let grant_db_usage varchar := 'GRANT USAGE ON DATABASE ' || row_variable.name || ' TO 
 ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_db_usage;

    --
    --GRANT USAGE ON DATABASE SCHEMAS
    --
    
    let grant_schema_usage varchar := 'GRANT USAGE ON ALL SCHEMAS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_schema_usage;

    --
    --GRANT USAGE ON FUTURE DATABASE SCHEMAS
    --
    
    let grant_future_schema varchar := 'GRANT USAGE ON FUTURE SCHEMAS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_future_schema;

    --
    -- GRANT SELECT ON ALL TABLES
    --

    let grant_select_tables varchar := 'GRANT SELECT ON ALL TABLES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_select_tables;
    
    --
    -- GRANT SELECT ON FUTURE TABLES
    --

    let grant_future_tables varchar := 'GRANT SELECT ON FUTURE TABLES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_future_tables;
    
    --
    -- GRANT SELECT ON ALL VIEWS
    --

    let grant_select_views varchar := 'GRANT SELECT ON ALL VIEWS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_select_views;

    --
    -- GRANT SELECT ON FUTURE VIEWS
    --

    let grant_future_views varchar := 'GRANT SELECT ON FUTURE VIEWS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_future_views;

    --
    -- GRANT ON MATERIALIZED VIEWS
    --

    let grant_select_materialized_views varchar := 'GRANT SELECT ON ALL MATERIALIZED VIEWS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_select_materialized_views;

    let grant_select_future_materialized_views varchar := 'GRANT SELECT ON FUTURE MATERIALIZED VIEWS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_select_future_materialized_views;  

    let grant_reference_materialized_views varchar := 'GRANT REFERENCES ON ALL MATERIALIZED VIEWS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_reference_materialized_views;

    let grant_reference_future_materialized_views varchar := 'GRANT REFERENCES ON FUTURE MATERIALIZED VIEWS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_reference_future_materialized_views;  

    --
    -- GRANT MONITOR ON ALERTS
    --

    let grant_monitor_alerts varchar := 'GRANT MONITOR ON ALL ALERTS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_monitor_alerts;

    let grant_monitor_future_alerts varchar := 'GRANT MONITOR ON FUTURE ALERTS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_monitor_future_alerts;
    

    --
    -- GRANT ON DYNAMIC TABLES
    --

    let grant_operate_dynamic_tables varchar := 'GRANT OPERATE ON ALL DYNAMIC TABLES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_operate_dynamic_tables;

    let grant_op_future_dynamic_tables varchar := 'GRANT OPERATE ON FUTURE DYNAMIC TABLES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_op_future_dynamic_tables;  

    let grant_select_dynamic_tables varchar := 'GRANT SELECT ON ALL DYNAMIC TABLES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_select_dynamic_tables;

    let grant_select_future_dynamic_tables varchar := 'GRANT SELECT ON FUTURE DYNAMIC TABLES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_select_future_dynamic_tables;

    --
    -- GRANT ON EVENT TABLES
    --

    let grant_operate_event_tables varchar := 'GRANT SELECT ON ALL EVENT TABLES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_operate_event_tables;

    let grant_op_future_event_tables varchar := 'GRANT SELECT ON FUTURE EVENT TABLES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_op_future_event_tables;  

    --
    -- GRANT ON FILE FORMATS
    --

    let grant_usage_file_format varchar := 'GRANT USAGE ON ALL FILE FORMATS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_usage_file_format;

    let grant_usage_future_file_format varchar := 'GRANT USAGE ON FUTURE FILE FORMATS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_usage_future_file_format;  

    --
    -- GRANT ON FUNCTIONS
    --

    let grant_usage_functions varchar := 'GRANT USAGE ON ALL FUNCTIONS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_usage_functions;

    let grant_usage_future_functions varchar := 'GRANT USAGE ON FUTURE FUNCTIONS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_usage_future_functions;  
 
    --
    -- GRANT ON PROCEDURE
    --

    let grant_usage_procedures varchar := 'GRANT USAGE ON ALL PROCEDURES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_usage_procedures;

    let grant_usage_future_procedures varchar := 'GRANT USAGE ON FUTURE PROCEDURES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_usage_future_procedures;  
  
    --
    -- GRANT ON SEQUENCE
    --

    let grant_usage_sequences varchar := 'GRANT USAGE ON ALL SEQUENCES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_usage_sequences;

    let grant_usage_future_sequences varchar := 'GRANT USAGE ON FUTURE SEQUENCES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_usage_future_sequences;  

    --
    -- GRANT ON MODEL
    --

    let grant_usage_models varchar := 'GRANT USAGE ON ALL MODELS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_usage_models;

    --
    -- currently errors with message unsupported feature MODULE
    -- todo: resolve error
    --
    --let grant_usage_future_models varchar := 'GRANT USAGE ON FUTURE MODELS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    --EXECUTE IMMEDIATE :grant_usage_future_models; 
  
    --
    -- GRANT ON IMAGE REPOSITORY
    --

    let grant_read_image_repositories varchar := 'GRANT READ ON ALL IMAGE REPOSITORIES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_read_image_repositories;

    let grant_read_future_image_repositories varchar := 'GRANT READ ON FUTURE IMAGE REPOSITORIES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_read_future_image_repositories;  

    --
    -- GRANT ON ICEBERG TABLE
    --

    let grant_select_iceberg_tables varchar := 'GRANT SELECT ON ALL ICEBERG TABLEs IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_select_iceberg_tables;

    let grant_select_future_iceberg_tables varchar := 'GRANT SELECT ON FUTURE ICEBERG TABLES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_select_future_iceberg_tables;  

    let grant_reference_iceberg_tables varchar := 'GRANT REFERENCES ON ALL ICEBERG TABLEs IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_reference_iceberg_tables;

    let grant_reference_future_iceberg_tables varchar := 'GRANT REFERENCES ON FUTURE ICEBERG TABLES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_reference_future_iceberg_tables;  

    --
    -- GRANT ON PIPE
    --
	/*
    let grant_monitor_pipe varchar := 'GRANT MONITOR ON ALL PIPES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_monitor_pipe;

    let grant_monitor_future_pipe varchar := 'GRANT MONITOR ON FUTURE PIPES IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_monitor_future_pipe;  
*/
    --
    -- GRANT ON TASK
    --

    let grant_monitor_task varchar := 'GRANT MONITOR ON ALL TASKS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_monitor_task;

    let grant_monitor_future_task varchar := 'GRANT MONITOR ON FUTURE TASKS IN DATABASE ' || row_variable.name || ' TO ROLE ACCT_ADMIN_READONLY';
    EXECUTE IMMEDIATE :grant_monitor_future_task;  


  END FOR;
  
  RETURN TABLE(db_names);
END;

$$
;