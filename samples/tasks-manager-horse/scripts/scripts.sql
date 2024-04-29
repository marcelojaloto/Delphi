CREATE TABLE public.tasks
(
    id uuid NOT NULL,
    title character varying(100) NOT NULL,
    notes character varying(1000),
    created_date timestamp without time zone NOT NULL,
    status integer NOT NULL,
    priority integer NOT NULL,
    end_date timestamp without time zone,
    CONSTRAINT tasks_pkey PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public.tasks
    OWNER to postgres;

