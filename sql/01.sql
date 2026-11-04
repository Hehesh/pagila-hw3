SELECT COUNT(*) AS count
FROM public.customer AS c
JOIN public.address AS a ON a.address_id = c.address_id
