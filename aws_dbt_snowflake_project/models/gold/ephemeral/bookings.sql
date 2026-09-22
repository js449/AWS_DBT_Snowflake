{{
  config(
    materialized = 'ephemeral',
    )
}}
{# This is an ephemeral model for the bookings table,
ephemeral models are the models that are not materialized as physical tables in the database instead
, they are used to create intermediate results that are used in other models. 
    we just need to set configuration either in the model file or in the dbt_project.yml file#}

{# CTE's - using common table expressions to retrieve data from the source(obt),
so that we can perform further transformations or select data from it without creating a physical table, instead
create scd's dimension tables in database through snapshots#}
WITH bookings AS 
(
    SELECT 
        BOOKING_ID,
        BOOKING_DATE,
        BOOKING_STATUS,
        CREATED_AT
    FROM 
        {{ ref('obt') }}
)
SELECT * FROM bookings