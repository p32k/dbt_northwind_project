with source as (
    select
        p.id as product_id,
        p.product_code,
        p.product_name,
        p.description,
        s.company as supplier_company,
        p.standard_cost,
        p.list_price,
        p.reorder_level,
        p.target_level,
        p.quantity_per_unit,
        p.discontinued,
        p.minimum_reorder_quantity,
        p.category,
        p.attachments,
        current_timestamp() as insertion_timestamp
    from {{ref('stg_products')}} as p
    -- join supplier id to get company name
    left join {{ref('stg_suppliers')}} as s 
    on s.id = p.supplier_id
),
unique_source as (
    select *,
            row_number() over(partition by product_id) as row_number
    from source
)
select *
except (row_number)
from unique_source
where row_number = 1