--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.14
-- Dumped by pg_dump version 9.5.14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: posts_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.posts_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      begin
        new.tsv :=
          to_tsvector('simple', unaccent(coalesce(new.title::text, ''))) ||
          to_tsvector('simple', unaccent(coalesce(new.description::text, ''))) ||
          to_tsvector('simple', unaccent(coalesce(new.tags::text, '')));
        return new;
      end
      $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    id integer NOT NULL,
    accountable_id integer,
    accountable_type character varying,
    balance integer DEFAULT 0,
    max_allowed_balance integer,
    min_allowed_balance integer,
    flagged boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    organization_id integer
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_admin_comments (
    id integer NOT NULL,
    namespace character varying,
    body text,
    resource_id character varying NOT NULL,
    resource_type character varying NOT NULL,
    author_id integer,
    author_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_admin_comments_id_seq OWNED BY public.active_admin_comments.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name_translations public.hstore
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: device_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.device_tokens (
    id integer NOT NULL,
    user_id integer NOT NULL,
    token character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: device_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.device_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: device_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.device_tokens_id_seq OWNED BY public.device_tokens.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.documents (
    id integer NOT NULL,
    documentable_id integer,
    documentable_type character varying,
    title text,
    content text,
    label character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id integer NOT NULL,
    action integer NOT NULL,
    post_id integer,
    member_id integer,
    transfer_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.members (
    id integer NOT NULL,
    user_id integer,
    organization_id integer,
    manager boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    entry_date date,
    member_uid integer,
    active boolean DEFAULT true
);


--
-- Name: members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.members_id_seq OWNED BY public.members.id;


--
-- Name: movements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.movements (
    id integer NOT NULL,
    account_id integer,
    transfer_id integer,
    amount integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: movements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.movements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: movements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.movements_id_seq OWNED BY public.movements.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    reg_number_seq integer,
    theme character varying,
    email character varying,
    phone character varying,
    web character varying,
    public_opening_times text,
    description text,
    address text,
    neighborhood character varying,
    city character varying,
    domain character varying
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.posts (
    id integer NOT NULL,
    title character varying,
    type character varying,
    category_id integer,
    user_id integer,
    description text,
    start_on date,
    end_on date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    tags text[],
    organization_id integer,
    active boolean DEFAULT true,
    is_group boolean DEFAULT false,
    tsv tsvector
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: push_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.push_notifications (
    id integer NOT NULL,
    event_id integer NOT NULL,
    device_token_id integer NOT NULL,
    processed_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL,
    body character varying DEFAULT ''::character varying NOT NULL,
    data json DEFAULT '{}'::json NOT NULL
);


--
-- Name: push_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.push_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: push_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.push_notifications_id_seq OWNED BY public.push_notifications.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: transfers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transfers (
    id integer NOT NULL,
    post_id integer,
    reason text,
    operator_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transfers_id_seq OWNED BY public.transfers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying NOT NULL,
    email character varying NOT NULL,
    date_of_birth date,
    identity_document character varying,
    phone character varying,
    alt_phone character varying,
    address text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    gender character varying,
    description text,
    active boolean DEFAULT true,
    terms_accepted_at timestamp without time zone,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0,
    unlock_token character varying,
    locked_at timestamp without time zone,
    locale character varying DEFAULT 'es'::character varying,
    notifications boolean DEFAULT true,
    push_notifications boolean DEFAULT true NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_admin_comments ALTER COLUMN id SET DEFAULT nextval('public.active_admin_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_tokens ALTER COLUMN id SET DEFAULT nextval('public.device_tokens_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members ALTER COLUMN id SET DEFAULT nextval('public.members_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movements ALTER COLUMN id SET DEFAULT nextval('public.movements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.push_notifications ALTER COLUMN id SET DEFAULT nextval('public.push_notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfers ALTER COLUMN id SET DEFAULT nextval('public.transfers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: device_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_tokens
    ADD CONSTRAINT device_tokens_pkey PRIMARY KEY (id);


--
-- Name: documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);


--
-- Name: movements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movements
    ADD CONSTRAINT movements_pkey PRIMARY KEY (id);


--
-- Name: organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: push_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.push_notifications
    ADD CONSTRAINT push_notifications_pkey PRIMARY KEY (id);


--
-- Name: transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_accountable_type_and_accountable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_accountable_type_and_accountable_id ON public.accounts USING btree (accountable_type, accountable_id);


--
-- Name: index_accounts_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_organization_id ON public.accounts USING btree (organization_id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON public.active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_namespace ON public.active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON public.active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_device_tokens_on_user_id_and_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_device_tokens_on_user_id_and_token ON public.device_tokens USING btree (user_id, token);


--
-- Name: index_documents_on_documentable_id_and_documentable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_documentable_id_and_documentable_type ON public.documents USING btree (documentable_id, documentable_type);


--
-- Name: index_documents_on_label; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_label ON public.documents USING btree (label);


--
-- Name: index_events_on_member_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_member_id ON public.events USING btree (member_id) WHERE (member_id IS NOT NULL);


--
-- Name: index_events_on_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_post_id ON public.events USING btree (post_id) WHERE (post_id IS NOT NULL);


--
-- Name: index_events_on_transfer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_transfer_id ON public.events USING btree (transfer_id) WHERE (transfer_id IS NOT NULL);


--
-- Name: index_members_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_members_on_organization_id ON public.members USING btree (organization_id);


--
-- Name: index_members_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_members_on_user_id ON public.members USING btree (user_id);


--
-- Name: index_movements_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_movements_on_account_id ON public.movements USING btree (account_id);


--
-- Name: index_movements_on_transfer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_movements_on_transfer_id ON public.movements USING btree (transfer_id);


--
-- Name: index_organizations_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_organizations_on_name ON public.organizations USING btree (name);


--
-- Name: index_posts_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_category_id ON public.posts USING btree (category_id);


--
-- Name: index_posts_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_organization_id ON public.posts USING btree (organization_id);


--
-- Name: index_posts_on_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_tags ON public.posts USING gin (tags);


--
-- Name: index_posts_on_tsv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_tsv ON public.posts USING gin (tsv);


--
-- Name: index_posts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_user_id ON public.posts USING btree (user_id);


--
-- Name: index_transfers_on_operator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transfers_on_operator_id ON public.transfers USING btree (operator_id);


--
-- Name: index_transfers_on_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transfers_on_post_id ON public.transfers USING btree (post_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.posts FOR EACH ROW EXECUTE PROCEDURE public.posts_trigger();


--
-- Name: events_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id);


--
-- Name: events_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id);


--
-- Name: events_transfer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_transfer_id_fkey FOREIGN KEY (transfer_id) REFERENCES public.transfers(id);


--
-- Name: fk_rails_1ceb778440; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT fk_rails_1ceb778440 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: fk_rails_36fb6ef1a8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.push_notifications
    ADD CONSTRAINT fk_rails_36fb6ef1a8 FOREIGN KEY (device_token_id) REFERENCES public.device_tokens(id);


--
-- Name: fk_rails_79a395b2d7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.push_notifications
    ADD CONSTRAINT fk_rails_79a395b2d7 FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('20121019101022');

INSERT INTO schema_migrations (version) VALUES ('20121104004639');

INSERT INTO schema_migrations (version) VALUES ('20121104085711');

INSERT INTO schema_migrations (version) VALUES ('20121121233818');

INSERT INTO schema_migrations (version) VALUES ('20130214175758');

INSERT INTO schema_migrations (version) VALUES ('20130214181128');

INSERT INTO schema_migrations (version) VALUES ('20130222185624');

INSERT INTO schema_migrations (version) VALUES ('20130425165150');

INSERT INTO schema_migrations (version) VALUES ('20130508085004');

INSERT INTO schema_migrations (version) VALUES ('20130513092219');

INSERT INTO schema_migrations (version) VALUES ('20130514094755');

INSERT INTO schema_migrations (version) VALUES ('20130618210236');

INSERT INTO schema_migrations (version) VALUES ('20130621102219');

INSERT INTO schema_migrations (version) VALUES ('20130621103053');

INSERT INTO schema_migrations (version) VALUES ('20130621103501');

INSERT INTO schema_migrations (version) VALUES ('20130621105452');

INSERT INTO schema_migrations (version) VALUES ('20130703233851');

INSERT INTO schema_migrations (version) VALUES ('20130703234011');

INSERT INTO schema_migrations (version) VALUES ('20130703234042');

INSERT INTO schema_migrations (version) VALUES ('20130723160206');

INSERT INTO schema_migrations (version) VALUES ('20131017144321');

INSERT INTO schema_migrations (version) VALUES ('20131025202608');

INSERT INTO schema_migrations (version) VALUES ('20131027215517');

INSERT INTO schema_migrations (version) VALUES ('20131029202724');

INSERT INTO schema_migrations (version) VALUES ('20131103221044');

INSERT INTO schema_migrations (version) VALUES ('20131104004235');

INSERT INTO schema_migrations (version) VALUES ('20131104013634');

INSERT INTO schema_migrations (version) VALUES ('20131104013829');

INSERT INTO schema_migrations (version) VALUES ('20131104032622');

INSERT INTO schema_migrations (version) VALUES ('20131220160257');

INSERT INTO schema_migrations (version) VALUES ('20131227110122');

INSERT INTO schema_migrations (version) VALUES ('20131227142805');

INSERT INTO schema_migrations (version) VALUES ('20131227155440');

INSERT INTO schema_migrations (version) VALUES ('20131231110424');

INSERT INTO schema_migrations (version) VALUES ('20140119161433');

INSERT INTO schema_migrations (version) VALUES ('20140513141718');

INSERT INTO schema_migrations (version) VALUES ('20140514225527');

INSERT INTO schema_migrations (version) VALUES ('20150329193421');

INSERT INTO schema_migrations (version) VALUES ('20150330200315');

INSERT INTO schema_migrations (version) VALUES ('20150422162806');

INSERT INTO schema_migrations (version) VALUES ('20180221161343');

INSERT INTO schema_migrations (version) VALUES ('20180501093846');

INSERT INTO schema_migrations (version) VALUES ('20180514193153');

INSERT INTO schema_migrations (version) VALUES ('20180524143938');

INSERT INTO schema_migrations (version) VALUES ('20180525141138');

INSERT INTO schema_migrations (version) VALUES ('20180529144243');

INSERT INTO schema_migrations (version) VALUES ('20180530180546');

INSERT INTO schema_migrations (version) VALUES ('20180604145622');

INSERT INTO schema_migrations (version) VALUES ('20180828160700');

INSERT INTO schema_migrations (version) VALUES ('20180831161349');

INSERT INTO schema_migrations (version) VALUES ('20180924164456');

INSERT INTO schema_migrations (version) VALUES ('20181004200104');

INSERT INTO schema_migrations (version) VALUES ('20190319121401');

INSERT INTO schema_migrations (version) VALUES ('20190322180602');

INSERT INTO schema_migrations (version) VALUES ('20190411192828');

INSERT INTO schema_migrations (version) VALUES ('20190412163011');

INSERT INTO schema_migrations (version) VALUES ('20190523213421');

INSERT INTO schema_migrations (version) VALUES ('20190523225323');

