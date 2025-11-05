--
-- PostgreSQL database dump
--

\restrict 4jCZfsQjtr4z2kfxpJHq5ybkp1eNW4bTrc5aCe3vdmU216IjUuI51o0evNcMz1y

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: analytics; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA analytics;


ALTER SCHEMA analytics OWNER TO postgres;

--
-- Name: goaltracker; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA goaltracker;


ALTER SCHEMA goaltracker OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accountability_buddies; Type: TABLE; Schema: goaltracker; Owner: admin
--

CREATE TABLE goaltracker.accountability_buddies (
    id integer NOT NULL,
    user_id integer NOT NULL,
    buddy_id integer NOT NULL,
    realationship_type character varying(50) DEFAULT 'buddy'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE goaltracker.accountability_buddies OWNER TO admin;

--
-- Name: accountability_buddies_id_seq; Type: SEQUENCE; Schema: goaltracker; Owner: admin
--

CREATE SEQUENCE goaltracker.accountability_buddies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE goaltracker.accountability_buddies_id_seq OWNER TO admin;

--
-- Name: accountability_buddies_id_seq; Type: SEQUENCE OWNED BY; Schema: goaltracker; Owner: admin
--

ALTER SEQUENCE goaltracker.accountability_buddies_id_seq OWNED BY goaltracker.accountability_buddies.id;


--
-- Name: goal_viewers; Type: TABLE; Schema: goaltracker; Owner: admin
--

CREATE TABLE goaltracker.goal_viewers (
    id integer NOT NULL,
    goal_id integer NOT NULL,
    viewer_id integer NOT NULL,
    permission_level character varying(50) DEFAULT 'view'::character varying,
    craeted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE goaltracker.goal_viewers OWNER TO admin;

--
-- Name: goal_viewers_id_seq; Type: SEQUENCE; Schema: goaltracker; Owner: admin
--

CREATE SEQUENCE goaltracker.goal_viewers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE goaltracker.goal_viewers_id_seq OWNER TO admin;

--
-- Name: goal_viewers_id_seq; Type: SEQUENCE OWNED BY; Schema: goaltracker; Owner: admin
--

ALTER SEQUENCE goaltracker.goal_viewers_id_seq OWNED BY goaltracker.goal_viewers.id;


--
-- Name: goals; Type: TABLE; Schema: goaltracker; Owner: admin
--

CREATE TABLE goaltracker.goals (
    id integer NOT NULL,
    user_id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    status character varying(50) DEFAULT 'active'::character varying,
    is_public boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE goaltracker.goals OWNER TO admin;

--
-- Name: goals_id_seq; Type: SEQUENCE; Schema: goaltracker; Owner: admin
--

CREATE SEQUENCE goaltracker.goals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE goaltracker.goals_id_seq OWNER TO admin;

--
-- Name: goals_id_seq; Type: SEQUENCE OWNED BY; Schema: goaltracker; Owner: admin
--

ALTER SEQUENCE goaltracker.goals_id_seq OWNED BY goaltracker.goals.id;


--
-- Name: tasks; Type: TABLE; Schema: goaltracker; Owner: admin
--

CREATE TABLE goaltracker.tasks (
    id integer NOT NULL,
    goal_id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    completed boolean DEFAULT false,
    points integer DEFAULT 0,
    due_date timestamp without time zone,
    completed_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE goaltracker.tasks OWNER TO admin;

--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: goaltracker; Owner: admin
--

CREATE SEQUENCE goaltracker.tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE goaltracker.tasks_id_seq OWNER TO admin;

--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: goaltracker; Owner: admin
--

ALTER SEQUENCE goaltracker.tasks_id_seq OWNED BY goaltracker.tasks.id;


--
-- Name: users; Type: TABLE; Schema: goaltracker; Owner: admin
--

CREATE TABLE goaltracker.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    username character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE goaltracker.users OWNER TO admin;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: goaltracker; Owner: admin
--

CREATE SEQUENCE goaltracker.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE goaltracker.users_id_seq OWNER TO admin;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: goaltracker; Owner: admin
--

ALTER SEQUENCE goaltracker.users_id_seq OWNED BY goaltracker.users.id;


--
-- Name: accountability_buddies id; Type: DEFAULT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.accountability_buddies ALTER COLUMN id SET DEFAULT nextval('goaltracker.accountability_buddies_id_seq'::regclass);


--
-- Name: goal_viewers id; Type: DEFAULT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.goal_viewers ALTER COLUMN id SET DEFAULT nextval('goaltracker.goal_viewers_id_seq'::regclass);


--
-- Name: goals id; Type: DEFAULT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.goals ALTER COLUMN id SET DEFAULT nextval('goaltracker.goals_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.tasks ALTER COLUMN id SET DEFAULT nextval('goaltracker.tasks_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.users ALTER COLUMN id SET DEFAULT nextval('goaltracker.users_id_seq'::regclass);


--
-- Name: accountability_buddies accountability_buddies_pkey; Type: CONSTRAINT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.accountability_buddies
    ADD CONSTRAINT accountability_buddies_pkey PRIMARY KEY (id);


--
-- Name: accountability_buddies accountability_buddies_user_id_buddy_id_key; Type: CONSTRAINT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.accountability_buddies
    ADD CONSTRAINT accountability_buddies_user_id_buddy_id_key UNIQUE (user_id, buddy_id);


--
-- Name: goal_viewers goal_viewers_goal_id_viewer_id_key; Type: CONSTRAINT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.goal_viewers
    ADD CONSTRAINT goal_viewers_goal_id_viewer_id_key UNIQUE (goal_id, viewer_id);


--
-- Name: goal_viewers goal_viewers_pkey; Type: CONSTRAINT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.goal_viewers
    ADD CONSTRAINT goal_viewers_pkey PRIMARY KEY (id);


--
-- Name: goals goals_pkey; Type: CONSTRAINT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: idx_accountability_buddies_buddy_id; Type: INDEX; Schema: goaltracker; Owner: admin
--

CREATE INDEX idx_accountability_buddies_buddy_id ON goaltracker.accountability_buddies USING btree (buddy_id);


--
-- Name: idx_accountability_buddies_user_id; Type: INDEX; Schema: goaltracker; Owner: admin
--

CREATE INDEX idx_accountability_buddies_user_id ON goaltracker.accountability_buddies USING btree (user_id);


--
-- Name: idx_goal_viewers_goal_id; Type: INDEX; Schema: goaltracker; Owner: admin
--

CREATE INDEX idx_goal_viewers_goal_id ON goaltracker.goal_viewers USING btree (goal_id);


--
-- Name: idx_goal_viewers_viewer_id; Type: INDEX; Schema: goaltracker; Owner: admin
--

CREATE INDEX idx_goal_viewers_viewer_id ON goaltracker.goal_viewers USING btree (viewer_id);


--
-- Name: idx_goals_user_id; Type: INDEX; Schema: goaltracker; Owner: admin
--

CREATE INDEX idx_goals_user_id ON goaltracker.goals USING btree (user_id);


--
-- Name: idx_tasks_goal_id; Type: INDEX; Schema: goaltracker; Owner: admin
--

CREATE INDEX idx_tasks_goal_id ON goaltracker.tasks USING btree (goal_id);


--
-- Name: accountability_buddies accountability_buddies_buddy_id_fkey; Type: FK CONSTRAINT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.accountability_buddies
    ADD CONSTRAINT accountability_buddies_buddy_id_fkey FOREIGN KEY (buddy_id) REFERENCES goaltracker.users(id) ON DELETE CASCADE;


--
-- Name: accountability_buddies accountability_buddies_user_id_fkey; Type: FK CONSTRAINT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.accountability_buddies
    ADD CONSTRAINT accountability_buddies_user_id_fkey FOREIGN KEY (user_id) REFERENCES goaltracker.users(id) ON DELETE CASCADE;


--
-- Name: goal_viewers goal_viewers_goal_id_fkey; Type: FK CONSTRAINT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.goal_viewers
    ADD CONSTRAINT goal_viewers_goal_id_fkey FOREIGN KEY (goal_id) REFERENCES goaltracker.goals(id) ON DELETE CASCADE;


--
-- Name: goal_viewers goal_viewers_viewer_id_fkey; Type: FK CONSTRAINT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.goal_viewers
    ADD CONSTRAINT goal_viewers_viewer_id_fkey FOREIGN KEY (viewer_id) REFERENCES goaltracker.users(id) ON DELETE CASCADE;


--
-- Name: goals goals_user_id_fkey; Type: FK CONSTRAINT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.goals
    ADD CONSTRAINT goals_user_id_fkey FOREIGN KEY (user_id) REFERENCES goaltracker.users(id) ON DELETE CASCADE;


--
-- Name: tasks tasks_goal_id_fkey; Type: FK CONSTRAINT; Schema: goaltracker; Owner: admin
--

ALTER TABLE ONLY goaltracker.tasks
    ADD CONSTRAINT tasks_goal_id_fkey FOREIGN KEY (goal_id) REFERENCES goaltracker.goals(id) ON DELETE CASCADE;


--
-- Name: SCHEMA analytics; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA analytics TO admin;


--
-- Name: SCHEMA goaltracker; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA goaltracker TO admin;


--
-- PostgreSQL database dump complete
--

\unrestrict 4jCZfsQjtr4z2kfxpJHq5ybkp1eNW4bTrc5aCe3vdmU216IjUuI51o0evNcMz1y

