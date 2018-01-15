--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.6
-- Dumped by pg_dump version 9.6.6

-- Started on 2018-01-15 09:27:39

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12387)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2770 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 374 (class 1255 OID 17747)
-- Name: addemergency(integer, integer, integer, character, character, integer, integer, integer, boolean, boolean, boolean, boolean, integer, character, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION addemergency(user_id integer, assign_by integer, address_id integer, assign_date character, schedule_date character, total_sample integer, sample_required integer, status integer, coliform boolean, copper boolean, metals boolean, emergency_sample boolean, emergency_type integer, comments character, distribution_id integer) RETURNS TABLE(id integer)
    LANGUAGE sql
    AS $$
	INSERT INTO public."task" (
	user_id , 
	assign_by ,
	address_id ,
	assign_date  ,
	schedule_date  ,
	total_sample ,
	sample_required ,
	status,
	coliform  ,
	copper ,
	metals ,
	emergency_sample   ,
	emergency_type ,
	comments,
	distribution_id
	) VALUES (
	user_id , 
	assign_by ,
	address_id ,
	assign_date  ,
	schedule_date  ,
	total_sample ,
	sample_required ,
	status,
	coliform  ,
	copper ,
	metals ,
	emergency_sample ,
	emergency_type,
	comments ,
	distribution_id  
	) RETURNING id
$$;


--
-- TOC entry 365 (class 1255 OID 17743)
-- Name: assigncontainer(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION assigncontainer(cid integer, assigned_to integer, assigned_by integer) RETURNS void
    LANGUAGE sql
    AS $$ 
  update public.containers set assigned_to = assigncontainer.assigned_to, assigned_by = assigncontainer.assigned_by, updated_at = now()
  where id=assigncontainer.cid;	 
$$;


--
-- TOC entry 327 (class 1255 OID 17367)
-- Name: assigncontainertosampler(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION assigncontainertosampler(sampler_id integer, assigned_by integer, container_id integer, status integer) RETURNS void
    LANGUAGE sql
    AS $$

          
          update containers set assigned_to =assignContainerToSampler.sampler_id,assigned_by=assignContainerToSampler.assigned_by,status=assignContainerToSampler.status
          where id=assignContainerToSampler.container_id;
                 
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 207 (class 1259 OID 16442)
-- Name: user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "user" (
    id integer NOT NULL,
    username character varying,
    email character varying,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone DEFAULT now(),
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone DEFAULT now(),
    last_sign_in_at timestamp without time zone DEFAULT now(),
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp without time zone DEFAULT now(),
    confirmation_sent_at timestamp without time zone DEFAULT now(),
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone DEFAULT now(),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    interface_preference integer DEFAULT 0 NOT NULL,
    firstname character varying,
    lastname character varying,
    active boolean,
    started_date date,
    termination_date date,
    access_token character varying,
    token_expire_time character varying,
    middlename character varying,
    phone_number character varying,
    operator_license_no character varying,
    phone_number_2 character varying,
    license_expires character varying,
    distribution_system_id integer,
    license_grade_level character varying,
    permission_level character varying,
    roles character varying,
    systems character varying,
    license_id integer,
    logged_in boolean DEFAULT false
);


--
-- TOC entry 287 (class 1255 OID 16461)
-- Name: checkemailexist(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION checkemailexist(email character varying) RETURNS SETOF "user"
    LANGUAGE sql
    AS $$
	SELECT * FROM public.user where email = checkEmailExist.email;
$$;


--
-- TOC entry 192 (class 1259 OID 16407)
-- Name: distribution_system_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE distribution_system_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 215 (class 1259 OID 16594)
-- Name: distribution_system; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE distribution_system (
    id integer DEFAULT nextval('distribution_system_id_seq'::regclass) NOT NULL,
    name character varying,
    population integer DEFAULT 0 NOT NULL,
    is_suspended boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    incubation_length_hours integer,
    incubation_reading_length_hours integer,
    primacy_gency character varying,
    "EPA_region" character varying,
    primacy_type character varying,
    pws_activity character varying,
    pws_type character varying,
    "GW_SW" character varying,
    owner_type character varying,
    pop_cat_desc character varying,
    primacy_source character varying,
    "PWS_id" character varying
);


--
-- TOC entry 296 (class 1255 OID 16932)
-- Name: checkpwsidexist(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION checkpwsidexist(pws_ids character varying) RETURNS SETOF distribution_system
    LANGUAGE sql
    AS $$
SELECT * FROM public.distribution_system where "PWS_id" = checkpwsidexist.pws_ids;
$$;


--
-- TOC entry 288 (class 1255 OID 16462)
-- Name: checkuseremail(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION checkuseremail(email character varying) RETURNS TABLE(id integer, email character, encrypted_password character, failed_attempts integer, active boolean)
    LANGUAGE sql
    AS $$
SELECT id,
		email, 
		encrypted_password,
		failed_attempts, 
		active 
		FROM public.user where email = checkuseremail.email ORDER BY id DESC;

$$;


--
-- TOC entry 289 (class 1255 OID 16463)
-- Name: checkusernameexist(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION checkusernameexist(username character varying) RETURNS SETOF "user"
    LANGUAGE sql
    AS $$
	SELECT * FROM public.user where username = checkUsernameExist.username;
$$;


--
-- TOC entry 336 (class 1255 OID 17300)
-- Name: createtask(integer, integer, integer, character, character, integer, integer, integer, boolean, boolean, boolean, boolean, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION createtask(user_id integer, assign_by integer, address_id integer, assign_date character, schedule_date character, total_sample integer, sample_required integer, status integer, coliform boolean, copper boolean, metals boolean, emergency_sample boolean, phone_no character) RETURNS TABLE(id integer)
    LANGUAGE sql
    AS $$
	INSERT INTO public."task" (
	user_id , 
	assign_by ,
	address_id ,
	assign_date  ,
	schedule_date  ,
	total_sample ,
	sample_required ,
	status,
	coliform  ,
	copper ,
	metals ,
	emergency_sample   ,
	phone_no 
	
	) VALUES (
	user_id , 
	assign_by ,
	address_id ,
	assign_date  ,
	schedule_date  ,
	total_sample ,
	sample_required ,
	status,
	coliform  ,
	copper ,
	metals ,
	emergency_sample ,
	phone_no   
	) RETURNING id
$$;


--
-- TOC entry 355 (class 1255 OID 17716)
-- Name: currentincubatorcycle(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION currentincubatorcycle(distribution_id integer, ready_status integer, incubating_status integer, expired_status integer) RETURNS TABLE(id integer, assigned_to integer, assigned_by integer, date_issued timestamp without time zone, time_issued timestamp without time zone, disposer_id integer, disposal_reason character, created_at timestamp without time zone, updated_at timestamp without time zone, time_used timestamp without time zone, "QR_code" character, "bar_Code" character, "scan_via_QR" boolean, scan_via_bar boolean, status integer, incubation_start timestamp without time zone, incubation_end timestamp without time zone, comments text, distribution_id integer)
    LANGUAGE sql
    AS $$

  SELECT 
  containers.id ,
  containers.assigned_to ,
  containers.assigned_by , 
  containers.date_issued  , 
  containers.time_issued  ,
  containers.disposer_id ,
  containers.disposal_reason  ,
  containers.created_at  ,
  containers.updated_at  ,
  containers.time_used  ,
  containers."QR_code"  ,
  containers."bar_Code"  ,
  containers."scan_via_QR" ,
  containers.scan_via_bar ,
  containers.status  ,
  containers.incubation_start  ,
  containers.incubation_end ,
  containers.comments ,
  containers.distribution_id 
  from containers
  where distribution_id=CurrentIncubatorCycle.distribution_id 
  and  (status=CurrentIncubatorCycle.ready_status OR status=CurrentIncubatorCycle.incubating_status OR status=CurrentIncubatorCycle.expired_status)
  and assigned_to IS NULL
  and assigned_by IS NULL

$$;


--
-- TOC entry 290 (class 1255 OID 16464)
-- Name: deletealertmsgbyid(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION deletealertmsgbyid(alert_id integer, message_type integer) RETURNS void
    LANGUAGE sql
    AS $$

	  update public."alert" set message_type = deletealertmsgbyid.message_type
          where id=deletealertmsgbyid.alert_id;

$$;


--
-- TOC entry 244 (class 1255 OID 16465)
-- Name: deleterolesbyuseridanddistributorid(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION deleterolesbyuseridanddistributorid(user_id integer, distributor_id integer) RETURNS void
    LANGUAGE sql
    AS $$

    delete  from  user_distribution_roles 
    where  user_id=deleterolesByUserIdAndDistributorId.user_id 
    and  db_system_id=deleterolesByUserIdAndDistributorId.distributor_id
    
$$;


--
-- TOC entry 313 (class 1255 OID 17074)
-- Name: deletesamplesite(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION deletesamplesite(sample_sites_address_id integer) RETURNS void
    LANGUAGE sql
    AS $$

   DELETE  from "sample_sites_notes" where sample_sites_address_id=deletesampleSite.sample_sites_address_id;
   DELETE  from "sample_sites_owner" where sample_sites_address_id=deletesampleSite.sample_sites_address_id;
   DELETE  from "sample_sites_address" where id=deletesampleSite.sample_sites_address_id;

$$;


--
-- TOC entry 302 (class 1255 OID 17310)
-- Name: deletetask(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION deletetask(task_id integer, is_delete integer) RETURNS void
    LANGUAGE sql
    AS $$
   
	UPDATE task set is_delete=deleteTask.is_delete   
	where id=deleteTask.task_id
$$;


--
-- TOC entry 258 (class 1255 OID 16467)
-- Name: deleteuserbyid(integer, integer, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION deleteuserbyid(userid integer, address_id integer, coordinate_id integer, plant_address_id integer, user_distribution_roles integer, user_address_id integer) RETURNS void
    LANGUAGE sql
    AS $$

   DELETE  from "user_distribution_roles" where id=deleteuserbyid.user_distribution_roles;
   DELETE from "coordinate" where id=deleteuserbyid.coordinate_id;
   DELETE  from "address" where id=deleteuserbyid.address_id;
   DELETE  from "plant_address" where id=deleteuserbyid.plant_address_id;
   DELETE  from "user_address" where id=deleteuserbyid.user_address_id;

   DELETE  from "user" where id=deleteUserById.userId;
$$;


--
-- TOC entry 259 (class 1255 OID 16468)
-- Name: deleteuserbyid(integer, integer, integer, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION deleteuserbyid(distribution_system_id integer, userid integer, address_id integer, coordinate_id integer, plant_address_id integer, user_distribution_roles integer, user_address_id integer) RETURNS void
    LANGUAGE sql
    AS $$
		DELETE  from "user_address" where user_id=deleteuserbyid.userid AND address_id=deleteuserbyid.address_id; ;
		DELETE  from "plant_address" where id=deleteuserbyid.plant_address_id;
		DELETE  from "user_distribution_roles" where id=deleteuserbyid.user_distribution_roles;
	         DELETE  from "address" where id=deleteuserbyid.address_id;
		DELETE from "coordinate" where id=deleteuserbyid.coordinate_id;
		DELETE  from "user" where id=deleteuserbyid.userid;
$$;


--
-- TOC entry 357 (class 1255 OID 17800)
-- Name: deleteuserrole(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION deleteuserrole(distribution_system_id integer, userid integer) RETURNS void
    LANGUAGE sql
    AS $$
   DELETE  from "user_distribution_roles" where user_id=deleteuserRole.userId  AND db_system_id=deleteuserRole.distribution_system_id; 
$$;


--
-- TOC entry 312 (class 1255 OID 17068)
-- Name: getaccountinfo(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getaccountinfo(userid integer, distribution_id integer) RETURNS TABLE(billing_id integer, billing_user_id integer, street_1 character, street_2 character, city character, state character, zip character, card_type character, card_name character, card_expiry_month character, card_expiry_year character, card_ccv character, card_no character, address_street_1 character, address_street_2 character, address_city character, address_state character, address_zip character, id integer, username character, firstname character, middlename character, lastname character, operator_license_no character, phone_number character, email character, phone_number_2 character, license_expires character, user_license_id integer, active boolean, started_date date, termination_date date, coordinate_id integer, latitude numeric, longitude numeric, user_id integer, address_id integer, lience_id integer, license_type character)
    LANGUAGE sql
    AS $$
SELECT 


  distribution_billing_address.id ,
  distribution_billing_address.distribution_id ,
  distribution_billing_address.street_1  ,
  distribution_billing_address.street_2  ,
  distribution_billing_address.city  ,
  distribution_billing_address.state  ,
  distribution_billing_address.zip  ,
  distribution_billing_address.card_type  ,
  distribution_billing_address.card_name  ,
  distribution_billing_address.card_expiry_month  ,
  distribution_billing_address.card_expiry_year  ,
  distribution_billing_address.card_ccv  ,
  distribution_billing_address.card_no  ,


address.street_1,address.street_2,address.city,
address.state,address.zip,

"user".id as user_ids,"user".username,"user".firstname,"user".middlename,"user".lastname,"user".operator_license_no,"user".phone_number,"user".email,"user".phone_number_2,"user".license_expires,"user".license_id,"user".active,"user".started_date,"user".termination_date,


coordinate.id,
coordinate.latitude,
coordinate. longitude,

user_address.user_id ,
user_address.address_id ,

lience.id,
lience."type"

FROM  "address" left join "user_address"  on "address".id=user_address.address_id
 left join  distribution_billing_address  on distribution_billing_address.distribution_id=getAccountInfo.distribution_id
left join  coordinate on coordinate.id=address.coordinate_id

join  "user" on "user".id=user_address.user_id
left join  "lience" on lience.id="user".license_id

where   "user_address".user_id=getAccountInfo.userid
$$;


--
-- TOC entry 261 (class 1255 OID 16471)
-- Name: getalerts(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getalerts(current_user_id integer) RETURNS TABLE(user_id integer, firstname character, lastname character, email character, alert_id integer, message_type integer, current_user_recipient_id integer, message character, acknowledged_at timestamp without time zone, subject character)
    LANGUAGE sql
    AS $$

SELECT
	"user".id,
	"user".firstname,
	"user".lastname,
	"user".email,
	alert.id,
	alert.message_type,
	alert.recipient_id,
	alert.message,
	alert.acknowledged_at,
	alert.subject

	FROM  "user" 
	join "alert"  on "user".id=alert.sender_id
	WHERE "user".id NOT IN (getAlerts.current_user_id) 
	and alert.recipient_id=getAlerts.current_user_id  
	AND alert.message_type=1
$$;


--
-- TOC entry 358 (class 1255 OID 17762)
-- Name: getallroles(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getallroles() RETURNS TABLE(id integer, name character)
    LANGUAGE sql
    AS $$

  SELECT 
  
    role.id  ,
    role.name 
    from role

$$;


--
-- TOC entry 307 (class 1255 OID 17063)
-- Name: getallsamplesites(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getallsamplesites(distribution_id integer) RETURNS TABLE(sample_sites_owner_id integer, owner_firstname character, owner_lastname character, owner_contact_number character, address_id integer, latitude numeric, longitude numeric, street_1 character, street_2 character, city character, state character, zip character, distribution_id integer, sample_sites_notes_id integer, notes text)
    LANGUAGE sql
    AS $$
SELECT sample_sites_owner.id as sample_sites_owner_id, sample_sites_owner.owner_firstname,sample_sites_owner.owner_lastname,sample_sites_owner.owner_contact_number,

sample_sites_address.id as sample_sites_address_id, sample_sites_address.latitude, sample_sites_address.longitude, sample_sites_address.street_1,sample_sites_address.street_2, sample_sites_address.city, sample_sites_address.state, sample_sites_address.zip,sample_sites_address.distribution_id,

sample_sites_notes.id as sample_sites_notes_id, sample_sites_notes.notes

FROM sample_sites_owner 
join sample_sites_address on sample_sites_owner.sample_sites_address_id = sample_sites_address.id 
join sample_sites_notes  on sample_sites_notes.sample_sites_address_id = sample_sites_address.id
WHERE sample_sites_address.distribution_id=getAllSampleSites.distribution_id
 
$$;


--
-- TOC entry 329 (class 1255 OID 17531)
-- Name: getallstatus(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getallstatus() RETURNS TABLE(status_id integer, status character, created_at timestamp without time zone)
    LANGUAGE sql
    AS $$

  SELECT 
  
    status.id  ,
    status.status ,
    status.created_at 
    from status

$$;


--
-- TOC entry 366 (class 1255 OID 17740)
-- Name: getalltaskcount(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getalltaskcount(distribution_id integer) RETURNS TABLE(count bigint)
    LANGUAGE sql
    AS $$

  SELECT count(*)

   from task where  distribution_id=getAllTaskCount.distribution_id

$$;


--
-- TOC entry 334 (class 1255 OID 17236)
-- Name: getassignedcontainer(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getassignedcontainer(sampler_id integer) RETURNS TABLE(id integer, assigned_to integer, assigned_by integer, date_issued timestamp without time zone, time_issued timestamp without time zone, disposer_id integer, disposal_reason character, created_at timestamp without time zone, updated_at timestamp without time zone, time_used timestamp without time zone, "QR_code" character, "bar_Code" character, "scan_via_QR" boolean, scan_via_bar boolean, status integer, incubation_start timestamp without time zone, incubation_end timestamp without time zone, status_id integer, status_name text, comments text)
    LANGUAGE sql
    AS $$
  SELECT 
	  containers.id ,
	  containers.assigned_to ,
	  containers.assigned_by  , -- labtech
	  containers.date_issued  , -- labtech assigned when  scan
	  containers.time_issued  ,
	  containers.disposer_id  , -- labtech
	  containers.disposal_reason  ,
	  containers.created_at  ,
	  containers.updated_at  ,
	  containers.time_used  ,
	  containers."QR_code"  ,
	  containers."bar_Code"  ,
	  containers."scan_via_QR" ,
	  containers.scan_via_bar ,
	  containers.status  ,
	  containers.incubation_start  ,
	  containers.incubation_end ,
	  status.id ,
	  status.status ,
	  containers.comments
  from public.containers
  left join status on status.id=containers.status
  where assigned_to=getassignedcontainer.sampler_id
$$;


--
-- TOC entry 367 (class 1255 OID 17749)
-- Name: getbillingdetails(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getbillingdetails(distribution_id integer) RETURNS TABLE(id integer, distribution_id integer, street_1 character, street_2 character, city character, state character, zip character, card_type character, card_name character, card_expiry_month character, card_expiry_year character, card_no character, card_ccv character)
    LANGUAGE sql
    AS $$

SELECT 
	id, 
	distribution_id, 
	street_1, 
	street_2,
	city, 
	state, 
	zip, 
	card_type,
	card_name,
	card_expiry_month,
	card_expiry_year,
	card_no,
	card_ccv
       FROM public.distribution_billing_address
       where distribution_id = getbillingdetails.distribution_id;
       
$$;


--
-- TOC entry 316 (class 1255 OID 17106)
-- Name: getboardingadditionalinfo(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getboardingadditionalinfo(distribution_id integer) RETURNS TABLE(distribution_id integer, pws_location_country character varying, pws_location_town character varying, entry_point_distribution_address character varying, entry_point_distribution_city character varying, entry_point_distribution_state character varying, entry_point_distribution_zip character, water_plant_address character varying, water_plant_city character varying, water_plant_state character varying, water_plant_zip character varying)
    LANGUAGE sql
    AS $$
SELECT boarding_additional_info_location.distribution_id,boarding_additional_info_location.pws_location_country,boarding_additional_info_location.pws_location_town,boarding_additional_info_location.entry_point_distribution_address,boarding_additional_info_location.entry_point_distribution_city,boarding_additional_info_location.entry_point_distribution_state,boarding_additional_info_location.entry_point_distribution_zip,boarding_additional_info_location.water_plant_address,boarding_additional_info_location.water_plant_city,boarding_additional_info_location.water_plant_state,boarding_additional_info_location.water_plant_zip  from boarding_additional_info_location where distribution_id=getboardingadditionalinfo.distribution_id
$$;


--
-- TOC entry 359 (class 1255 OID 17773)
-- Name: getchlorinegauge(integer, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getchlorinegauge(distribution_id integer, schedule_start_date character, schedule_end_date character) RETURNS TABLE(id integer, container_id integer, sample_user_id integer, fixture character, temperature character, turbidity character, chlorine character, ph_level character, delete_type integer, samples_created_at timestamp without time zone, samples_updated_at timestamp without time zone, sample_task_id integer, samples_coliform boolean, task_id integer, user_id integer, assign_by integer, address_id integer, assign_date character, schedule_date character, completed_date character, created_at timestamp without time zone, updated_at timestamp without time zone, total_sample integer, sample_required integer, task_status_id integer, coliform boolean, copper boolean, metals boolean, emergency_sample boolean, phone_no character, is_delete integer, distribution_id integer, status_id integer, status character)
    LANGUAGE sql
    AS $$
SELECT 

  samples.id  ,
  samples.container_id  ,
  samples.user_id  ,
  samples.fixture  ,
  samples.temperature  ,
  samples.turbidity  ,
  samples.chlorine  ,
  samples.ph_level  ,
  samples.delete_type  ,
  samples.created_at  ,
  samples.updated_at  ,
  samples.task_id  ,
  samples.coliform  ,



 task.id ,
 task.user_id , 
 task.assign_by ,
 task.address_id , 
 task.assign_date  ,
 task.schedule_date  ,
 task.completed_date  ,
 task.created_at  ,
 task.updated_at  ,
 task.total_sample ,
 task.sample_required ,
 task.status ,
 task.coliform ,
 task.copper  ,
 task.metals  ,
 task.emergency_sample  ,
 task.phone_no,
 task.is_delete,
 task.distribution_id,
 status.id ,
 status.status 


  FROM  "task" 
  join samples on samples.task_id=task.id
  left join status on status.id =task.status
  where   (CAST(task.created_at as TEXT)>=getChlorineGauge.schedule_start_date and  CAST(task.created_at as TEXT)<=getChlorineGauge.schedule_end_date) 
   AND (task.distribution_id=getChlorineGauge.distribution_id  AND task.is_delete=0);

  
$$;


--
-- TOC entry 262 (class 1255 OID 16473)
-- Name: getcontacts(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getcontacts(db_system_id integer) RETURNS TABLE(id integer, username character, firstname character, middlename character, lastname character, phone_number character, email character, user_ids integer, db_system_id integer)
    LANGUAGE sql
    AS $$
SELECT 



	"user".id as user_ids,
	"user".username,
	"user".firstname,
	"user".middlename,
	"user".lastname,
	"user".phone_number,
	"user".email,


	user_distribution_roles.user_id ,
	user_distribution_roles.db_system_id 

	FROM  "user" 
	join user_distribution_roles  on  user_distribution_roles.user_id="user".id
	where   "user_distribution_roles".db_system_id=getContacts.db_system_id group by  "user".id ,db_system_id ,user_id
	

$$;


--
-- TOC entry 291 (class 1255 OID 16474)
-- Name: getcontacts(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getcontacts(user_id integer, db_system_id integer) RETURNS TABLE(id integer, username character, firstname character, middlename character, lastname character, phone_number character, email character, user_ids integer, db_system_id integer)
    LANGUAGE sql
    AS $$
SELECT 

"user".id as user_ids,
"user".username,
"user".firstname,
"user".middlename,
"user".lastname,
"user".phone_number,
"user".email,

user_distribution_roles.user_id ,
user_distribution_roles.db_system_id 

FROM  "user" join user_distribution_roles  on  user_distribution_roles.user_id="user".id
 
where   "user_distribution_roles".db_system_id=getContacts.db_system_id 
and  user_id != getContacts.user_id group by  "user".id ,db_system_id ,user_id

$$;


--
-- TOC entry 375 (class 1255 OID 17806)
-- Name: getcontainerbarcodereadystatus(integer, character, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getcontainerbarcodereadystatus(distribution_id integer, bar_code character, ready_status_id integer) RETURNS TABLE(id integer, assigned_to integer, assigned_by integer, date_issued timestamp without time zone, time_issued timestamp without time zone, disposer_id integer, disposal_reason character, created_at timestamp without time zone, updated_at timestamp without time zone, time_used timestamp without time zone, "QR_code" character, "bar_Code" character, "scan_via_QR" boolean, scan_via_bar boolean, status integer, distribution_id integer, incubation_start timestamp without time zone, incubation_end timestamp without time zone, status_id integer, status_name text, comments text)
    LANGUAGE sql
    AS $$
  SELECT 
	  containers.id ,
	  containers.assigned_to ,
	  containers.assigned_by  , -- labtech
	  containers.date_issued  , -- labtech assigned when  scan
	  containers.time_issued  ,
	  containers.disposer_id  , -- labtech
	  containers.disposal_reason  ,
	  containers.created_at  ,
	  containers.updated_at  ,
	  containers.time_used  ,
	  containers."QR_code"  ,
	  containers."bar_Code"  ,
	  containers."scan_via_QR" ,
	  containers.scan_via_bar ,
	  containers.status,
	  containers.distribution_id,
	  containers.incubation_start  ,
	  containers.incubation_end ,
	  status.id ,
	  status.status ,
	  containers.comments
  from public.containers
  left join status on status.id=containers.status
  where containers."bar_Code"=getContainerBarCodeReadyStatus.bar_code 
  and containers.status=getContainerBarCodeReadyStatus.ready_status_id
  and distribution_id=getContainerBarCodeReadyStatus.distribution_id

$$;


--
-- TOC entry 376 (class 1255 OID 17808)
-- Name: getcontainerbycontaineridreadystatus(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getcontainerbycontaineridreadystatus(distribution_id integer, container_id integer, ready_status_id integer) RETURNS TABLE(id integer, assigned_to integer, assigned_by integer, date_issued timestamp without time zone, time_issued timestamp without time zone, disposer_id integer, disposal_reason character, created_at timestamp without time zone, updated_at timestamp without time zone, time_used timestamp without time zone, "QR_code" character, "bar_Code" character, "scan_via_QR" boolean, scan_via_bar boolean, status integer, distribution_id integer, incubation_start timestamp without time zone, incubation_end timestamp without time zone, status_id integer, status_name text, comments text)
    LANGUAGE sql
    AS $$
  SELECT 
	  containers.id ,
	  containers.assigned_to ,
	  containers.assigned_by  , -- labtech
	  containers.date_issued  , -- labtech assigned when  scan
	  containers.time_issued  ,
	  containers.disposer_id  , -- labtech
	  containers.disposal_reason  ,
	  containers.created_at  ,
	  containers.updated_at  ,
	  containers.time_used  ,
	  containers."QR_code"  ,
	  containers."bar_Code"  ,
	  containers."scan_via_QR" ,
	  containers.scan_via_bar ,
	  containers.status,
	  containers.distribution_id,
	  containers.incubation_start  ,
	  containers.incubation_end ,
	  status.id ,
	  status.status ,
	  containers.comments
  from public.containers
  left join status on status.id=containers.status
  where containers.id=getContainerByContainerIdReadyStatus.container_id 
  and containers.status=getContainerByContainerIdReadyStatus.ready_status_id
  and distribution_id=getContainerByContainerIdReadyStatus.distribution_id

$$;


--
-- TOC entry 352 (class 1255 OID 17718)
-- Name: getcontainerbydistributionid(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getcontainerbydistributionid(distribution_id integer) RETURNS TABLE(id integer, sampler_id integer, distribution_id integer, address_id integer, containers_amount integer, reagent character, pickup_from_lab integer, deliver integer, phone character, created_at timestamp without time zone, updated_at timestamp without time zone, user_id integer, firstname character, lastname character)
    LANGUAGE sql
    AS $$SELECT 
 request_container.id ,
 request_container.sampler_id ,
 request_container.distribution_id ,
 request_container.address_id , 
 request_container.containers_amount ,
 request_container.reagent ,
 request_container.pickup_from_lab ,
 request_container.deliver ,
 request_container.phone , 
 request_container.created_at,
 request_container.updated_at, 
 "user".id, "user".firstname , 
 "user".lastname 
 from public.request_container
 join "user" on "user".id=request_container.sampler_id 
 where distribution_id=getcontainerByDistributionId.distribution_id 
 AND containers_amount > 0$$;


--
-- TOC entry 378 (class 1255 OID 17804)
-- Name: getcontainerqrcodereadystatus(integer, character, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getcontainerqrcodereadystatus(distribution_id integer, qr_code character, ready_status_id integer) RETURNS TABLE(id integer, assigned_to integer, assigned_by integer, date_issued timestamp without time zone, time_issued timestamp without time zone, disposer_id integer, disposal_reason character, created_at timestamp without time zone, updated_at timestamp without time zone, time_used timestamp without time zone, "QR_code" character, "bar_Code" character, "scan_via_QR" boolean, scan_via_bar boolean, status integer, distribution_id integer, incubation_start timestamp without time zone, incubation_end timestamp without time zone, status_id integer, status_name text, comments text)
    LANGUAGE sql
    AS $$
  SELECT 
	  containers.id ,
	  containers.assigned_to ,
	  containers.assigned_by  , -- labtech
	  containers.date_issued  , -- labtech assigned when  scan
	  containers.time_issued  ,
	  containers.disposer_id  , -- labtech
	  containers.disposal_reason  ,
	  containers.created_at  ,
	  containers.updated_at  ,
	  containers.time_used  ,
	  containers."QR_code"  ,
	  containers."bar_Code"  ,
	  containers."scan_via_QR" ,
	  containers.scan_via_bar ,
	  containers.status,
	  containers.distribution_id,
	  containers.incubation_start  ,
	  containers.incubation_end ,
	  status.id ,
	  status.status ,
	  containers.comments
  from public.containers
  left join status on status.id=containers.status
  where containers."QR_code"=getContainerQRCodeReadyStatus.QR_code 
  and containers.status=getContainerQRCodeReadyStatus.ready_status_id
  and distribution_id=getContainerQRCodeReadyStatus.distribution_id

$$;


--
-- TOC entry 360 (class 1255 OID 17776)
-- Name: getcontainersinuse(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getcontainersinuse(distribution_id integer) RETURNS TABLE(id integer, assigned_to integer, assigned_by integer, date_issued timestamp without time zone, time_issued timestamp without time zone, status integer, distribution_id integer, user_id integer, username character, firstname character, lastname character)
    LANGUAGE sql
    AS $$
SELECT 

containers.id,containers.assigned_to,containers.assigned_by,
containers.date_issued,containers.time_issued, containers.status, containers.distribution_id,

"user".id as user_id,"user".username,"user".firstname,"user".lastname

FROM  containers 
 left join "user" on containers.assigned_to="user".id 
 where containers.distribution_id=getcontainersinuse.distribution_id
 and containers.assigned_to IS NOT NULL
 and containers.assigned_by IS NOT NULL
$$;


--
-- TOC entry 322 (class 1255 OID 17139)
-- Name: getdeletedalert(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getdeletedalert(current_user_id integer, message_types integer) RETURNS TABLE(user_id integer, firstname character, lastname character, email character, alert_id integer, sender_id integer, message_type integer, current_user_recipient_id integer, message character, acknowledged_at timestamp without time zone, subject character)
    LANGUAGE sql
    AS $$

	SELECT 
	"user".id,
	"user".firstname,
	"user".lastname,
	"user".email,
	alert.id,
	alert.sender_id,
	alert.message_type,
	alert.recipient_id,
	alert.message,
	alert.acknowledged_at,
	alert.subject
	FROM  "user" 
	join "alert"  on "user".id=alert.recipient_id 


	WHERE (alert.sender_id=getdeletedalert.current_user_id 
	OR alert.recipient_id=getdeletedalert.current_user_id) 
	and message_type=getdeletedalert.message_types
	
$$;


--
-- TOC entry 263 (class 1255 OID 16476)
-- Name: getdistributionsystem(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getdistributionsystem(pws_ids integer) RETURNS TABLE(distribution_id integer, pws_name character, population integer, primacy_gency character, "EPA_region" character, primacy_type character, pws_activity character, pws_type character, "GW_SW" character, owner_type character, pop_cat_desc character, primacy_source character, "PWS_id" character, username_val character, firstname_val character, middlename_val character, lastname_val character, encrypted_password_val character, active_val boolean, phone_number_val character, phone_number_2_val character, email_val character, license_type_val integer, operator_license_no_val character, license_expires_val character, started_date_val date, termination_date_val date, license_grade_level character, permission_level character, distribution_system_id integer, coordinate_id integer, street_1 character, street_2 character, city character, state character, zip character, distribution_id_details integer, address_id integer, user_id integer, lience_id integer, lience_type character, coordinate_table_id integer, latitude numeric, longitude numeric)
    LANGUAGE sql
    AS $$


SELECT distribution_system.id as distribution_id,distribution_system.name,distribution_system.population,
distribution_system.primacy_gency,distribution_system."EPA_region",distribution_system.primacy_type,distribution_system.pws_activity,distribution_system.pws_type,distribution_system."GW_SW",distribution_system.owner_type,distribution_system.pop_cat_desc,distribution_system.primacy_source,distribution_system."PWS_id" ,

 "user".username  ,
"user".firstname  ,
 "user".middlename  ,
 "user".lastname  ,
 "user".encrypted_password  ,
"user".active ,
"user".phone_number  ,
 "user".phone_number_2  ,
 "user".email  ,
"user".license_id ,
 "user".operator_license_no  ,
 "user".license_expires  ,
 "user".started_date,
 "user".termination_date ,
 "user".license_grade_level ,
 "user".permission_level ,
 "user".distribution_system_id ,

  address.coordinate_id ,
  address.street_1  ,
  address.street_2  ,
  address.city  ,
  address.state  ,
  address.zip ,
   
 distribution_id_details.distribution_id,
 distribution_id_details.address_id,
 distribution_id_details.user_id,
 lience.id  ,
 lience.type,
  coordinate.id  ,
  coordinate.latitude ,
  coordinate.longitude   
 
 
from distribution_id_details   
 left join   "user" on  distribution_id_details.user_id="user".id
 left join  address on  address.id= distribution_id_details.address_id
 left join  lience on  lience.id="user".license_id 
 left join  coordinate on coordinate.id= address.coordinate_id
 join distribution_system on distribution_system.id= distribution_id_details.distribution_id

where  distribution_system.id=getdistributionsystem.pws_ids

$$;


--
-- TOC entry 264 (class 1255 OID 16477)
-- Name: getdistributionsystembypwsid(character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getdistributionsystembypwsid(pws_ids character) RETURNS TABLE(distribution_id integer, pws_name character, population integer, primacy_gency character, "EPA_region" character, primacy_type character, pws_activity character, pws_type character, "GW_SW" character, owner_type character, pop_cat_desc character, primacy_source character, "PWS_id" character, username_val character, firstname_val character, middlename_val character, lastname_val character, encrypted_password_val character, active_val boolean, phone_number_val character, phone_number_2_val character, email_val character, license_type_val integer, operator_license_no_val character, license_expires_val character, started_date_val date, termination_date_val date, license_grade_level character, permission_level character, distribution_system_id integer, coordinate_id integer, street_1 character, street_2 character, city character, state character, zip character, distribution_id_details integer, address_id integer, user_id integer, lience_id integer, lience_type character, coordinate_table_id integer, latitude numeric, longitude numeric)
    LANGUAGE sql
    AS $$


SELECT distribution_system.id as distribution_id,distribution_system.name,distribution_system.population,
distribution_system.primacy_gency,distribution_system."EPA_region",distribution_system.primacy_type,distribution_system.pws_activity,distribution_system.pws_type,distribution_system."GW_SW",distribution_system.owner_type,distribution_system.pop_cat_desc,distribution_system.primacy_source,distribution_system."PWS_id" ,

 "user".username  ,
"user".firstname  ,
 "user".middlename  ,
 "user".lastname  ,
 "user".encrypted_password  ,
"user".active ,
"user".phone_number  ,
 "user".phone_number_2  ,
 "user".email  ,
"user".license_id ,
 "user".operator_license_no  ,
 "user".license_expires  ,
 "user".started_date,
 "user".termination_date ,
 "user".license_grade_level ,
 "user".permission_level ,
 "user".distribution_system_id ,

  address.coordinate_id ,
  address.street_1  ,
  address.street_2  ,
  address.city  ,
  address.state  ,
  address.zip ,
   
 distribution_id_details.distribution_id,
 distribution_id_details.address_id,
 distribution_id_details.user_id,
 lience.id  ,
 lience.type,
  coordinate.id  ,
  coordinate.latitude ,
  coordinate.longitude   
 
 
from distribution_id_details   
 left join   "user" on  distribution_id_details.user_id="user".id
 left join  address on  address.id= distribution_id_details.address_id
 left join  lience on  lience.id="user".license_id 
 left join  coordinate on coordinate.id= address.coordinate_id
 join distribution_system on distribution_system.id= distribution_id_details.distribution_id

where  distribution_system."PWS_id"=getdistributionsystembypwsid.pws_ids

$$;


--
-- TOC entry 292 (class 1255 OID 16478)
-- Name: getdraftalert(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getdraftalert(current_user_id integer, message_types integer) RETURNS TABLE(user_id integer, firstname character, lastname character, alert_id integer, receiver_id integer, message_type integer, current_user_recipient_id integer, message character, acknowledged_at timestamp without time zone, subject character)
    LANGUAGE sql
    AS $$

SELECT
	"user".id,
	"user".firstname,
	"user".lastname,
	alert.id,
	alert.sender_id,
	alert.message_type,
	alert.recipient_id,
	alert.message,
	alert.acknowledged_at,
	alert.subject

FROM  "user"
	join "alert"  
	on "user".id=alert.recipient_id
	WHERE alert.sender_id=getDraftalert.current_user_id 
	and alert.message_type=getDraftalert.message_types
   
$$;


--
-- TOC entry 349 (class 1255 OID 17494)
-- Name: getemergency(boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getemergency(emergency_sample_status boolean) RETURNS TABLE(task_id integer, user_id integer, assign_by integer, address_id integer, assign_date character, schedule_date character, total_sample integer, sample_required integer, status integer, coliform boolean, copper boolean, metals boolean, emergency_sample boolean, task_emergency_type integer, comments character, emergency_type_id integer, emergency_type character, id integer, latitude numeric, longitude numeric, street_1 character, street_2 character, city character, state character, zip character, type_of_sampling_location character, location_samplesite_used character, distribution_id integer)
    LANGUAGE sql
    AS $$
	SELECT 
	task.id,
	task.user_id , 
	task.assign_by ,
	task.address_id ,
	task.assign_date  ,
	task.schedule_date  ,
	task.total_sample ,
	task.sample_required ,
	task.status,
	task.coliform  ,
	task.copper ,
	task.metals ,
	task.emergency_sample   ,
	task.emergency_type ,
	task.comments,
	emergency_type.id,
	emergency_type.emergency_type,


	sample_sites_address.id,
	sample_sites_address.latitude ,
	sample_sites_address.longitude ,
	sample_sites_address.street_1  ,
	sample_sites_address.street_2  ,
	sample_sites_address.city  ,
	sample_sites_address.state  ,
	sample_sites_address.zip  ,
	sample_sites_address.type_of_sampling_location  ,
	sample_sites_address.location_samplesite_used  ,
	sample_sites_address.distribution_id 
  
	from task
	left join  emergency_type on emergency_type.id=task.emergency_type
	join  sample_sites_address on sample_sites_address.id=task.address_id
	where task.emergency_sample=getEmergency.emergency_sample_status
$$;


--
-- TOC entry 321 (class 1255 OID 17406)
-- Name: getemergencytypelist(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getemergencytypelist() RETURNS TABLE(id integer, emergency_type character)
    LANGUAGE sql
    AS $$
SELECT  
 id  ,
 emergency_type  

 FROM public.emergency_type 
$$;


--
-- TOC entry 368 (class 1255 OID 17738)
-- Name: getgaugeschedulestatus(integer, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getgaugeschedulestatus(distribution_id integer, schedule_start_date character, schedule_end_date character) RETURNS TABLE(id integer, container_id integer, sample_user_id integer, fixture character, temperature character, turbidity character, chlorine character, ph_level character, delete_type integer, samples_created_at timestamp without time zone, samples_updated_at timestamp without time zone, sample_task_id integer, samples_coliform boolean, task_id integer, user_id integer, assign_by integer, address_id integer, assign_date character, schedule_date character, completed_date character, created_at timestamp without time zone, updated_at timestamp without time zone, total_sample integer, sample_required integer, task_status_id integer, coliform boolean, copper boolean, metals boolean, emergency_sample boolean, phone_no character, distribution_id integer, status_id integer, status character)
    LANGUAGE sql
    AS $$
SELECT 

  samples.id  ,
  samples.container_id  ,
  samples.user_id  ,
  samples.fixture  ,
  samples.temperature  ,
  samples.turbidity  ,
  samples.chlorine  ,
  samples.ph_level  ,
  samples.delete_type  ,
  samples.created_at  ,
  samples.updated_at  ,
  samples.task_id  ,
  samples.coliform  ,



 task.id ,
 task.user_id , 
 task.assign_by ,
 task.address_id , 
 task.assign_date  ,
 task.schedule_date  ,
 task.completed_date  ,
 task.created_at  ,
 task.updated_at  ,
 task.total_sample ,
 task.sample_required ,
 task.status ,
 task.coliform ,
 task.copper  ,
 task.metals  ,
 task.emergency_sample  ,
 task.phone_no,
 task.distribution_id,
 status.id ,
 status.status 


  FROM  "task" 
  join samples on samples.task_id=task.id
  left join status on status.id =task.status
  where   (task.completed_date >=getGaugeScheduleStatus.schedule_start_date and  task.completed_date <=getGaugeScheduleStatus.schedule_end_date) 
   AND task.distribution_id=getGaugeScheduleStatus.distribution_id and task.status=1;

  
$$;


--
-- TOC entry 351 (class 1255 OID 17799)
-- Name: getlabtechresulthistory(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getlabtechresulthistory(distribution_id integer, status_fail_id integer, status_pass_id integer) RETURNS TABLE(id integer, assigned_to integer, assigned_by integer, date_issued timestamp without time zone, time_issued timestamp without time zone, status integer, incubation_start timestamp without time zone, incubation_end timestamp without time zone, comments text, distribution_id integer, reasons_for_failure text, user_id integer, firstname character, lastname character)
    LANGUAGE sql
    AS $$ SELECT containers.id,containers.assigned_to,containers.assigned_by, containers.date_issued,containers.time_issued, containers.status, containers.incubation_start, containers.incubation_end, containers.comments, containers.distribution_id, containers.reasons_for_failure, "user".id as user_id,"user".firstname,"user".lastname FROM containers left join "user" on containers.assigned_to="user".id where containers.distribution_id=getLabTechResultHistory.distribution_id and containers.assigned_to IS NOT NULL and containers.assigned_by IS NOT NULL and (status = getLabTechResultHistory.status_fail_id OR status = getLabTechResultHistory.status_pass_id) $$;


--
-- TOC entry 353 (class 1255 OID 17798)
-- Name: getlabtechresults(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getlabtechresults(distribution_id integer, status_fail_id integer, status_pass_id integer) RETURNS TABLE(id integer, assigned_to integer, assigned_by integer, date_issued timestamp without time zone, time_issued timestamp without time zone, status integer, incubation_start timestamp without time zone, incubation_end timestamp without time zone, distribution_id integer, user_id integer, username character, firstname character, lastname character)
    LANGUAGE sql
    AS $$
SELECT 

containers.id,containers.assigned_to,containers.assigned_by,
containers.date_issued,containers.time_issued, containers.status, containers.incubation_start,containers.incubation_end,containers.distribution_id,

"user".id as user_id,"user".username,"user".firstname,"user".lastname

FROM  containers 
 left join "user" on containers.assigned_to="user".id 
 where containers.distribution_id=getLabTechResults.distribution_id
 and containers.assigned_to IS NOT NULL
 and containers.assigned_by IS NOT NULL
 and (status !=getLabTechResults.status_fail_id AND status !=getLabTechResults.status_pass_id)
$$;


--
-- TOC entry 265 (class 1255 OID 16479)
-- Name: getlicencelist(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getlicencelist() RETURNS TABLE(id integer, type character)
    LANGUAGE sql
    AS $$
SELECT  
 id ,
 type 

 FROM public.lience 
$$;


--
-- TOC entry 266 (class 1255 OID 16480)
-- Name: getloginuser(character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getloginuser(email character varying, encrypted_password character varying) RETURNS SETOF "user"
    LANGUAGE sql
    AS $$
SELECT * FROM public.user where email = getLoginUser.email and encrypted_password=getLoginUser.encrypted_password;
$$;


--
-- TOC entry 341 (class 1255 OID 17272)
-- Name: getmanagersamplerdtl(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getmanagersamplerdtl(role_id integer, distribution_id integer) RETURNS TABLE(id integer, username character, firstname character, middlename character, lastname character, operator_license_no character, phone_number character, email character, phone_number_2 character, license_expires character, user_license_id integer, active boolean, started_date date, termination_date date, logged_in boolean, user_distribution_roles_user_id integer, user_distribution_roles_db_system_id integer, user_distribution_roles_roles_id integer)
    LANGUAGE sql
    AS $$
SELECT 




	"user".id as user_ids,
	"user".username,
	"user".firstname,
	"user".middlename,
	"user".lastname,
	"user".operator_license_no,
	"user".phone_number,
	"user".email,
	"user".phone_number_2,
	"user".license_expires,
	"user".license_id,
	"user".active,
	"user".started_date,
	"user".termination_date,
	"user". logged_in ,

	user_distribution_roles.user_id ,
	user_distribution_roles.db_system_id ,
	user_distribution_roles.roles_id

FROM  "user" 

join "user_distribution_roles"  on user_distribution_roles.user_id ="user".id
where user_distribution_roles.roles_id=getmanagerSamplerDtl.role_id  and  user_distribution_roles.db_system_id=getmanagerSamplerDtl.distribution_id

$$;


--
-- TOC entry 328 (class 1255 OID 17528)
-- Name: getmonthlygraph(character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getmonthlygraph(schedule_start_date character, schedule_end_date character) RETURNS TABLE(date_part double precision, count bigint)
    LANGUAGE sql
    AS $$
SELECT  
	
 date_part('month', CAST (schedule_date AS DATE)),
	count(*) from task 
	where schedule_date >=getmonthlygraph.schedule_start_date and schedule_date <=getmonthlygraph.schedule_end_date 
	group by date_part('month', CAST (schedule_date AS DATE)) 
order by date_part('month', CAST (schedule_date AS DATE)) ;

$$;


--
-- TOC entry 268 (class 1255 OID 16481)
-- Name: getonealert(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getonealert(alertid integer) RETURNS TABLE(alert_id integer, sender_id integer, message_type integer, recipient_id integer, message character, acknowledged_at timestamp without time zone, subject character)
    LANGUAGE sql
    AS $$
SELECT 

alert.id, 
alert.sender_id,
alert.message_type,
alert.recipient_id,
alert.message,
alert.acknowledged_at,
alert.subject

FROM  alert
WHERE alert.id = getonealert.alertid

$$;


--
-- TOC entry 377 (class 1255 OID 17807)
-- Name: getreadyrejectedcontainers(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getreadyrejectedcontainers(distribution_id integer, ready_status integer, rejected_status integer) RETURNS TABLE(id integer, assigned_to integer, assigned_by integer, date_issued timestamp without time zone, time_issued timestamp without time zone, disposer_id integer, disposal_reason character, created_at timestamp without time zone, updated_at timestamp without time zone, time_used timestamp without time zone, "QR_code" character, "bar_Code" character, "scan_via_QR" boolean, scan_via_bar boolean, status integer, incubation_start timestamp without time zone, incubation_end timestamp without time zone, comments text, distribution_id integer)
    LANGUAGE sql
    AS $$

  SELECT 
  containers.id ,
  containers.assigned_to ,
  containers.assigned_by , 
  containers.date_issued  , 
  containers.time_issued  ,
  containers.disposer_id ,
  containers.disposal_reason  ,
  containers.created_at  ,
  containers.updated_at  ,
  containers.time_used  ,
  containers."QR_code"  ,
  containers."bar_Code"  ,
  containers."scan_via_QR" ,
  containers.scan_via_bar ,
  containers.status  ,
  containers.incubation_start  ,
  containers.incubation_end ,
  containers.comments ,
  containers.distribution_id 
  from containers
  where distribution_id=getReadyRejectedContainers.distribution_id 
  and  (status=getReadyRejectedContainers.ready_status OR status=getReadyRejectedContainers.rejected_status)
  and assigned_to IS NOT NULL
  and assigned_by IS NOT NULL

$$;


--
-- TOC entry 267 (class 1255 OID 16482)
-- Name: getrolelist(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getrolelist() RETURNS TABLE(id integer, name character, nickname character)
    LANGUAGE sql
    AS $$
SELECT  
 id  ,
 name  ,
 nickname  

 FROM public.role 
$$;


--
-- TOC entry 344 (class 1255 OID 17309)
-- Name: getsamplesbytaskiddtl(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getsamplesbytaskiddtl(task_id integer) RETURNS TABLE(id integer, container_id integer, address_id integer, user_id integer, fixture character, temperature character, turbidity character, coliform boolean, chlorine character, ph_level character, delete_type integer, created_at timestamp without time zone, updated_at timestamp without time zone, task_id integer, containers_id integer, assigned_to integer, assigned_by integer, date_issued timestamp without time zone, time_issued timestamp without time zone, disposer_id integer, disposal_reason character, container_concreated_at timestamp without time zone, container_updated_at timestamp without time zone, time_used timestamp without time zone, "QR_code" character, "bar_Code" character, "scan_via_QR" boolean, scan_via_bar boolean, status integer, incubation_start timestamp without time zone, incubation_end timestamp without time zone, comments character, status_id integer, containers_status character)
    LANGUAGE sql
    AS $$
SELECT 
  samples.id  ,
  samples.container_id  ,
  samples.address_id ,
  samples.user_id  ,
  samples.fixture  ,
  samples.temperature  ,
  samples.turbidity  ,
  samples.coliform  ,
  samples.chlorine  ,
  samples.ph_level  ,
  samples.delete_type  ,
  samples.created_at  ,
  samples.updated_at  ,
  samples.task_id ,

  containers.id ,
  containers.assigned_to , -- sampler ids
  containers.assigned_by , -- labtech
  containers.date_issued , -- labtech assigned when  scan
  containers.time_issued ,
  containers.disposer_id , -- labtech
  containers.disposal_reason ,
  containers.created_at ,
  containers.updated_at ,
  containers.time_used ,
  containers."QR_code" ,
  containers."bar_Code" ,
  containers."scan_via_QR" ,
  containers.scan_via_bar ,
  containers.status ,
  containers.incubation_start ,
  containers.incubation_end ,
  containers.comments ,

   status.id,
   status.status
   
  FROM samples  
  Join containers on containers.id=samples.container_id
  left Join status on status.id=containers.status
  where  samples.task_id =getSamplesByTaskIdDtl.task_id  AND delete_type=0

  
$$;


--
-- TOC entry 332 (class 1255 OID 17232)
-- Name: getsampleshistory(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getsampleshistory(sample_site_address_id integer, show_limit integer) RETURNS TABLE(id integer, container_id integer, address_id integer, user_id integer, fixture character, temperature character, turbidity character, coliform character, chlorine character, ph_level character, delete_type integer, sample_created_at timestamp without time zone, sample_updated_at timestamp without time zone, sample_task_id integer, task_id integer, sampler_user_id integer, assign_by integer, sample_sites_address_id integer, assign_date character, schedule_date character, completed_date character, task_created_at timestamp without time zone, task_updated_at timestamp without time zone, total_sample integer, sample_required integer, task_status integer, status_id integer, status character)
    LANGUAGE sql
    AS $$
SELECT 
	samples.id  ,
	samples.container_id  ,
	samples.address_id ,
	samples.user_id  ,
	samples.fixture  ,
	samples.temperature  ,
	samples.turbidity  ,
	samples.coliform  ,
	samples.chlorine  ,
	samples.ph_level  ,
	samples.delete_type  ,
	samples.created_at  ,
	samples.updated_at  ,
	samples.task_id , 

	task.id ,
	task.user_id , -- Assign to(Current login user Type = Sampler )
	task.assign_by , -- Manager, Admin ids
	task.address_id , -- Sample Site Address Ids
	task.assign_date  ,
	task.schedule_date  ,
	task.completed_date  ,
	task.created_at ,
	task.updated_at ,
	task.total_sample ,
	task.sample_required ,
	task.status ,

	status.id ,
	status.status 

	FROM samples  
	join  task on task.id=samples.task_id
	left join  status on status.id=task.status
	where  task.address_id =getsamplesHistory.sample_site_address_id
	limit show_limit

  
$$;


--
-- TOC entry 333 (class 1255 OID 17235)
-- Name: getsamplesitesimages(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getsamplesitesimages(sample_sites_address_id integer) RETURNS TABLE(image_id integer, address_id integer, image_path character, caption character, created_at timestamp without time zone, updated_at timestamp without time zone)
    LANGUAGE sql
    AS $$

	SELECT 
	sample_site_images.id ,
	sample_site_images.address_id ,
	sample_site_images.image_path ,
	sample_site_images.caption ,
	sample_site_images.created_at,
	sample_site_images.updated_at 
	From sample_site_images  
	where address_id=getSampleSitesImages.sample_sites_address_id

$$;


--
-- TOC entry 347 (class 1255 OID 17485)
-- Name: getscheduluserlist(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getscheduluserlist(distribution_id integer) RETURNS TABLE(user_id integer, username character, email character, firstname character, lastname character, access_token character, token_expire_time character, report_schedule_id integer, distribution_id integer, report_schedule_user_id integer)
    LANGUAGE sql
    AS $$
SELECT 

"user".id,
"user".username, 
"user".email, 
"user".firstname, 
"user".lastname,

"user".access_token,
"user".token_expire_time,

  report_schedule.id,
  report_schedule.distribution_id ,
  report_schedule.user_id 
 from "user"
  join   report_schedule on    "user".id=report_schedule.user_id  

where distribution_id=getSchedulUserList.distribution_id ;

$$;


--
-- TOC entry 324 (class 1255 OID 17141)
-- Name: getsendalert(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getsendalert(current_user_id integer) RETURNS TABLE(user_id integer, firstname character, lastname character, alert_id integer, message_type integer, current_user_recipient_id integer, message character, acknowledged_at timestamp without time zone, subject character)
    LANGUAGE sql
    AS $$

SELECT 
"user".id,
"user".firstname,
"user".lastname,
alert.id,
alert.message_type,
alert.recipient_id,
alert.message,
alert.acknowledged_at,
alert.subject

FROM  "user" 
join "alert" on "user".id=alert.recipient_id
 WHERE   alert.recipient_id NOT IN (getSendAlert.current_user_id) and message_type=1
 
$$;


--
-- TOC entry 350 (class 1255 OID 17497)
-- Name: gettallnotesbyaddressid(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gettallnotesbyaddressid(address_id integer) RETURNS TABLE(sample_sites_notes_id integer, sample_sites_address_ids integer, notes text, created_at timestamp without time zone, updated_at timestamp without time zone)
    LANGUAGE sql
    AS $$
SELECT 


 sample_sites_notes.id  ,
 sample_sites_notes.sample_sites_address_id ,
 sample_sites_notes.notes ,
 sample_sites_notes.created_at,
 sample_sites_notes.updated_at
 


FROM  sample_sites_notes 

  where sample_sites_notes.sample_sites_address_id=gettallnotesbyaddressid.address_id    
  
$$;


--
-- TOC entry 340 (class 1255 OID 17266)
-- Name: gettallownerandnotesbyaddressid(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gettallownerandnotesbyaddressid(address_id integer) RETURNS TABLE(sample_sites_owner_id integer, owner_firstname character, owner_lastname character, owner_contact_number character, sample_sites_address_ids integer)
    LANGUAGE sql
    AS $$
SELECT 




 sample_sites_owner.id  ,
 sample_sites_owner.owner_firstname  ,
 sample_sites_owner.owner_lastname  ,
 sample_sites_owner.owner_contact_number,
 sample_sites_owner.sample_sites_address_id



FROM  sample_sites_owner 

  where sample_sites_owner.sample_sites_address_id=gettallOwnerAndNotesByAddressId.address_id    
  
$$;


--
-- TOC entry 342 (class 1255 OID 17275)
-- Name: gettallsamplesiteaddress(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gettallsamplesiteaddress(distribution_id integer) RETURNS TABLE(address_id integer, street_1 character, street_2 character, city character, state character, zip character, latitude numeric, longitude numeric, distribution_id integer)
    LANGUAGE sql
    AS $$
SELECT 

 sample_sites_address.id,
 sample_sites_address.street_1,
 sample_sites_address.street_2,
 sample_sites_address.city,
 sample_sites_address.state,
 sample_sites_address.zip, 
 sample_sites_address.latitude,
 sample_sites_address.longitude,
 sample_sites_address.distribution_id




FROM  "sample_sites_address" 

  where "sample_sites_address".distribution_id=gettallSampleSiteAddress.distribution_id   
  
$$;


--
-- TOC entry 269 (class 1255 OID 16486)
-- Name: gettalltasklistassigntosampler(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gettalltasklistassigntosampler(sampler_id integer) RETURNS TABLE(sample_sites_address_id integer, street_1 character, street_2 character, city character, state character, zip character, latitude numeric, longitude numeric, task_id integer, user_id integer, assign_by integer, address_id integer, assign_date character, schedule_date character, completed_date character, created_at timestamp without time zone, updated_at timestamp without time zone, total_sample integer, sample_required integer, task_status_id integer, coliform boolean, copper boolean, metals boolean, emergency_sample boolean, phone_no character, status_id integer, status character)
    LANGUAGE sql
    AS $$
SELECT 

 sample_sites_address.id,
 sample_sites_address.street_1,
 sample_sites_address.street_2,
 sample_sites_address.city,
 sample_sites_address.state,
 sample_sites_address.zip, 
 sample_sites_address.latitude,
 sample_sites_address.longitude,




 task.id ,
 task.user_id , 
 task.assign_by ,
 task.address_id , 
 task.assign_date  ,
 task.schedule_date  ,
 task.completed_date  ,
 task.created_at  ,
 task.updated_at  ,
 task.total_sample ,
 task.sample_required ,
 task.status ,
 task.coliform ,
 task.copper  ,
 task.metals  ,
 task.emergency_sample  ,
 task.phone_no,

 status.id ,
 status.status 


FROM  "task" 
  join sample_sites_address on sample_sites_address.id=task.address_id
  left join status on status.id =task.status
  where "task".user_id=gettAllTaskListAssignToSampler.sampler_id   
  
$$;


--
-- TOC entry 343 (class 1255 OID 17283)
-- Name: gettaskdutybysamplerid(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gettaskdutybysamplerid(sampler_id integer) RETURNS TABLE(id integer, latitude numeric, longitude numeric, street_1 character, street_2 character, city character, state character, zip character, created_at timestamp without time zone, updated_at timestamp without time zone, type_of_sampling_location character, location_samplesite_used character, distribution_id integer, task_id integer, user_id integer, assign_by integer, address_id integer, assign_date character, schedule_date character, completed_date character, task_created_at timestamp without time zone, task_updated_at timestamp without time zone, total_sample integer, sample_required integer, task_status integer, status_id integer, status_message character)
    LANGUAGE sql
    AS $$
SELECT 
	

          sample_sites_address.id  ,
	  sample_sites_address.latitude ,
	  sample_sites_address.longitude ,
	  sample_sites_address.street_1  ,
	  sample_sites_address.street_2  ,
	  sample_sites_address.city  ,
	  sample_sites_address.state  ,
	  sample_sites_address.zip  ,
	  sample_sites_address.created_at  ,
	  sample_sites_address.updated_at  ,
	  sample_sites_address.type_of_sampling_location  ,
	  sample_sites_address.location_samplesite_used  ,
	  sample_sites_address.distribution_id ,

	task.id ,
	task.user_id , -- Assign to(Current login user Type = Sampler )
	task.assign_by , -- Manager, Admin ids
	task.address_id , -- Sample Site Address Ids
	task.assign_date  ,
	task.schedule_date  ,
	task.completed_date  ,
	task.created_at ,
	task.updated_at ,
	task.total_sample ,
	task.sample_required ,
	task.status ,

	status.id ,
	status.status 

	FROM sample_sites_address  
	join  task on task.address_id=sample_sites_address.id
	 join  status on status.id=task.status
	where  task.user_id=getTaskDutyBySamplerId.sampler_id
	

  
$$;


--
-- TOC entry 354 (class 1255 OID 17504)
-- Name: gettaskmap(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gettaskmap(sampler_id integer) RETURNS TABLE(id integer, latitude numeric, longitude numeric, street_1 character, street_2 character, city character, state character, zip character, created_at timestamp without time zone, updated_at timestamp without time zone, type_of_sampling_location character, location_samplesite_used character, distribution_id integer, task_id integer, user_id integer, assign_by integer, address_id integer, assign_date character, schedule_date character, completed_date character, task_created_at timestamp without time zone, task_updated_at timestamp without time zone, total_sample integer, sample_required integer, task_status integer, task_coliform boolean, task_copper boolean, task_metals boolean, task_emergency_sample boolean, task_phone_no character, task_is_delete integer, task_emergency_type integer, status_id integer, status_message character, samples_id integer, samples_container_id integer, samples_address_id integer, samples_user_id integer, samples_fixture character, samples_temperature character, samples_turbidity character, samples_chlorine character, samples_ph_level character, samples_delete_type integer, samples_created_at timestamp without time zone, samples_updated_at timestamp without time zone, samples_task_id integer, samples_coliform boolean)
    LANGUAGE sql
    AS $$
SELECT 
	

          sample_sites_address.id  ,
	  sample_sites_address.latitude ,
	  sample_sites_address.longitude ,
	  sample_sites_address.street_1  ,
	  sample_sites_address.street_2  ,
	  sample_sites_address.city  ,
	  sample_sites_address.state  ,
	  sample_sites_address.zip  ,
	  sample_sites_address.created_at  ,
	  sample_sites_address.updated_at  ,
	  sample_sites_address.type_of_sampling_location  ,
	  sample_sites_address.location_samplesite_used  ,
	  sample_sites_address.distribution_id ,

	task.id ,
	task.user_id , -- Assign to(Current login user Type = Sampler )
	task.assign_by , -- Manager, Admin ids
	task.address_id , -- Sample Site Address Ids
	task.assign_date  ,
	task.schedule_date  ,
	task.completed_date  ,
	task.created_at ,
	task.updated_at ,
	task.total_sample ,
	task.sample_required ,
	task.status ,

	task.coliform ,
	task.copper ,
	task.metals ,
	task.emergency_sample ,
	task.phone_no ,
	task.is_delete ,
	task.emergency_type ,

	status.id ,
	status.status, 


	samples.id ,
	samples.container_id  ,
	samples.address_id  ,
	samples.user_id  ,
	samples.fixture  ,
	samples.temperature  ,
	samples.turbidity  ,
	samples.chlorine  ,
	samples.ph_level  ,
	samples.delete_type  ,
	samples.created_at  ,
	samples.updated_at  ,
	samples.task_id  ,
	samples.coliform  

	FROM sample_sites_address  
	join  task on task.address_id=sample_sites_address.id
	join  status on status.id=task.status
	join  samples on samples.task_id=task.id
	where  task.user_id=gettaskMap.sampler_id 
	AND task.is_delete=0

$$;


--
-- TOC entry 298 (class 1255 OID 16487)
-- Name: gettrackingdetails(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gettrackingdetails(id integer, token character varying) RETURNS TABLE(id integer, username character, email character, firstname character, lastname character, access_token character, token_expire_time character)
    LANGUAGE sql
    AS $$

SELECT 
	id, 
	username, 
	email,
	firstname,
	lastname, 
	access_token,
	token_expire_time 
	FROM public.user 
	where id=gettrackingdetails.id 
	and access_token= gettrackingdetails.token;
$$;


--
-- TOC entry 270 (class 1255 OID 16489)
-- Name: gettrackingdetailsbytoken(integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION gettrackingdetailsbytoken(id integer, token character varying, distribution_id integer) RETURNS TABLE(user_id integer, username character, email character, firstname character, lastname character, access_token character, token_expire_time character, role_table_id integer, name character, nickname character, "position" integer, created_at timestamp without time zone, updated_at timestamp without time zone, id integer, user_distribution_roles_user_id integer, db_system_id integer, roles_id integer)
    LANGUAGE sql
    AS $$
SELECT 

"user".id,
"user".username, 
"user".email, 
"user".firstname, 
"user".lastname,

"user".access_token,
"user".token_expire_time,

role.id ,
role.name ,
role.nickname ,
role."position"  ,
role.created_at ,
role.updated_at, 

user_distribution_roles.id ,
user_distribution_roles.user_id  ,
user_distribution_roles.db_system_id  ,
user_distribution_roles.roles_id 
 from role
  join   user_distribution_roles on    role.id=user_distribution_roles.roles_id 
   join   "user" on    "user".id=user_distribution_roles.user_id
where user_id=gettrackingdetailsbytoken.id and db_system_id= gettrackingdetailsbytoken.distribution_id;

$$;


--
-- TOC entry 345 (class 1255 OID 17321)
-- Name: getunusedandnotassignedcontainers(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getunusedandnotassignedcontainers(not_used_id integer, not_assigend integer, not_expired integer) RETURNS TABLE(id integer, assigned_to integer, assigned_by integer, date_issued timestamp without time zone, time_issued timestamp without time zone, disposer_id integer, disposal_reason character, created_at timestamp without time zone, updated_at timestamp without time zone, time_used timestamp without time zone, "QR_code" character, "bar_Code" character, "scan_via_QR" boolean, scan_via_bar boolean, status integer, incubation_start timestamp without time zone, incubation_end timestamp without time zone, status_id integer, status_name text, comments text)
    LANGUAGE sql
    AS $$
  SELECT 
	  containers.id ,
	  containers.assigned_to ,
	  containers.assigned_by  , -- labtech
	  containers.date_issued  , -- labtech assigned when  scan
	  containers.time_issued  ,
	  containers.disposer_id  , -- labtech
	  containers.disposal_reason  ,
	  containers.created_at  ,
	  containers.updated_at  ,
	  containers.time_used  ,
	  containers."QR_code"  ,
	  containers."bar_Code"  ,
	  containers."scan_via_QR" ,
	  containers.scan_via_bar ,
	  containers.status  ,
	  containers.incubation_start  ,
	  containers.incubation_end ,
	  status.id ,
	  status.status ,
	  containers.comments
  from public.containers
  left join status on status.id=containers.status
  where (containers.status !=getunUsedAndNotAssignedContainers.not_used_id and containers.status !=getunUsedAndNotAssignedContainers.not_assigend and containers.status !=getunUsedAndNotAssignedContainers.not_expired)
$$;


--
-- TOC entry 339 (class 1255 OID 17260)
-- Name: getunusedcontainer(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getunusedcontainer(userid integer) RETURNS TABLE(container_id integer, assigned_to integer, assigned_by integer, date_issued timestamp without time zone, time_issued timestamp without time zone, disposer_id integer, disposal_reason character, created_at timestamp without time zone, updated_at timestamp without time zone, time_used timestamp without time zone, "QR_code" character, "bar_Code" character, "scan_via_QR" boolean, scan_via_bar boolean, status integer, incubation_start timestamp without time zone, incubation_end timestamp without time zone, comments character, status_id integer, container_status character)
    LANGUAGE sql
    AS $$
SELECT 
  	containers.id  ,
	containers.assigned_to  , -- sampler ids
	containers.assigned_by  , -- labtech
	containers.date_issued  , -- labtech assigned when  scan
	containers.time_issued  ,
	containers.disposer_id , -- labtech
	containers.disposal_reason  ,
	containers.created_at  ,
	containers.updated_at  ,
	containers.time_used  ,
	containers."QR_code"  ,
	containers."bar_Code"  ,
	containers."scan_via_QR" ,
	containers.scan_via_bar ,
	containers.status  ,
	containers.incubation_start  ,
	containers.incubation_end ,
	containers.comments ,
	status.id,
	status.status
	 

FROM  containers
left join status on status.id=containers.status
WHERE   (assigned_to = getUnusedContainer.userid  and containers.status=6 )

$$;


--
-- TOC entry 323 (class 1255 OID 17140)
-- Name: getuserbesicinfo(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getuserbesicinfo(user_id integer) RETURNS TABLE(user_id integer, firstname character, lastname character, email character, phone_number character varying, operator_license_no character varying, phone_number_2 character varying, license_expires character varying, distribution_system_id integer, license_grade_level character varying, active boolean, started_date date, termination_date date)
    LANGUAGE sql
    AS $$

	SELECT 
	"user".id,
	"user".firstname,
	"user".lastname,
	"user".email,
	"user".phone_number ,
	"user".operator_license_no ,
	"user".phone_number_2 ,
	"user".license_expires ,
	"user".distribution_system_id ,
	"user".license_grade_level ,
	"user".active ,
	"user".started_date ,
	"user".termination_date 
  
	FROM  "user" 
	WHERE   "user".id=getuserBesicInfo.user_id

	
$$;


--
-- TOC entry 310 (class 1255 OID 17066)
-- Name: getuserdetails(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getuserdetails(userid integer) RETURNS TABLE(plant_address_id integer, user_idss integer, plant_address_street_1 character, plant_address_street_2 character, plant_address_city character, plant_address_state character, plant_address_zip character, address_street_1 character, address_street_2 character, address_city character, address_state character, address_zip character, id integer, username character, firstname character, middlename character, lastname character, operator_license_no character, phone_number character, email character, phone_number_2 character, license_expires character, user_license_id integer, active boolean, started_date date, termination_date date, coordinate_id integer, latitude numeric, longitude numeric, user_id integer, address_id integer, lience_id integer, license_type character)
    LANGUAGE sql
    AS $$
SELECT 

plant_address.id as plant_address_id,plant_address.user_id as user_id, plant_address.street_1,plant_address.street_2,plant_address.city,
plant_address.state,plant_address.zip,

address.street_1,address.street_2,address.city,
address.state,address.zip,

"user".id as user_ids,"user".username,"user".firstname,"user".middlename,"user".lastname,"user".operator_license_no,"user".phone_number,"user".email,"user".phone_number_2,"user".license_expires,"user".license_id,"user".active,"user".started_date,"user".termination_date,


coordinate.id,
coordinate.latitude,
coordinate. longitude,

user_address.user_id ,
user_address.address_id ,

lience.id,
lience."type"

FROM  "address" left join "user_address"  on "address".id=user_address.address_id
 left join  plant_address on plant_address.user_id=getUserDetails.userId
left join  coordinate on coordinate.id=address.coordinate_id

 join  "user" on "user".id=user_address.user_id
left join  "lience" on lience.id="user".license_id

where   "user_address".user_id=getuserdetails.userid
$$;


--
-- TOC entry 318 (class 1255 OID 17110)
-- Name: getusersbydistributorid(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getusersbydistributorid(distribution_id integer) RETURNS TABLE(db_system_id integer, user_id integer)
    LANGUAGE sql
    AS $$

SELECT 
	user_distribution_roles.db_system_id,
	user_distribution_roles.user_id

	FROM user_distribution_roles  
	where  db_system_id=getusersByDistributorId.distribution_id 
	GROUP BY  db_system_id,user_id order by user_id DESC;

$$;


--
-- TOC entry 379 (class 1255 OID 17746)
-- Name: getusersystem(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getusersystem(user_id integer) RETURNS TABLE(db_system_id integer, user_id integer, distribution_system_name character, "PWS_id" character, distribution_system_id integer)
    LANGUAGE sql
    AS $$
SELECT 


	user_distribution_roles.db_system_id,
	user_distribution_roles.user_id,
	distribution_system.name,
	distribution_system."PWS_id",
	distribution_system.id
	FROM user_distribution_roles
	join  distribution_system on user_distribution_roles.db_system_id=distribution_system.id
	where  user_id=getUserSystem.user_id
	
	GROUP BY   name, distribution_system.id ,db_system_id,user_id;
  
$$;


--
-- TOC entry 271 (class 1255 OID 16493)
-- Name: getusersystemrole(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getusersystemrole(user_id integer, db_system_id integer) RETURNS TABLE(role_table_id integer, name character, nickname character, "position" integer, created_at timestamp without time zone, updated_at timestamp without time zone, id integer, user_id integer, db_system_id integer, roles_id integer)
    LANGUAGE sql
    AS $$
SELECT 

  role.id ,
  role.name ,
  role.nickname ,
  role."position"  ,
  role.created_at ,
  role.updated_at, 
  
  user_distribution_roles.id ,
  user_distribution_roles.user_id  ,
  user_distribution_roles.db_system_id  ,
  user_distribution_roles.roles_id 
  FROM  role 
  join   user_distribution_roles on    role.id=user_distribution_roles.roles_id 
   where  user_id=getUserSystemRole.user_id AND   db_system_id=getUserSystemRole.db_system_id
 
  
$$;


--
-- TOC entry 330 (class 1255 OID 17529)
-- Name: getweeklygraph(character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getweeklygraph(schedule_start_date character, schedule_end_date character) RETURNS TABLE(date_part double precision, count bigint)
    LANGUAGE sql
    AS $$
SELECT  
	
 date_part('day', CAST (schedule_date AS DATE)),
	count(*) from task 
	where schedule_date >=getweeklygraph.schedule_start_date and schedule_date <=getweeklygraph.schedule_end_date 
	group by date_part('day', CAST (schedule_date AS DATE)) 
order by date_part('day', CAST (schedule_date AS DATE)) ;

$$;


--
-- TOC entry 331 (class 1255 OID 17530)
-- Name: getyeargraph(character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION getyeargraph(schedule_start_date character, schedule_end_date character) RETURNS TABLE(date_part double precision, count bigint)
    LANGUAGE sql
    AS $$
SELECT  
	
 date_part('year', CAST (schedule_date AS DATE)),
	count(*) from task 
	where schedule_date >=getyeargraph.schedule_start_date and schedule_date <=getyeargraph.schedule_end_date 
	group by date_part('year', CAST (schedule_date AS DATE)) 
order by date_part('year', CAST (schedule_date AS DATE)) ;

$$;


--
-- TOC entry 243 (class 1255 OID 16494)
-- Name: harddeletealert(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION harddeletealert(alert_id integer) RETURNS void
    LANGUAGE sql
    AS $$
   DELETE  from "alert" where id=harddeletealert.alert_id;


$$;


--
-- TOC entry 326 (class 1255 OID 17221)
-- Name: insertadditionalmonitering(character, character, character, character, character, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertadditionalmonitering(sampling_frequency character, complaince_requirements character, sampling_comments character, notes character, contaminants character, distribution_id integer) RETURNS TABLE(id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public.distribution_additional_monitering  (
  sampling_frequency ,
  complaince_requirements ,
  sampling_comments ,
  notes ,
  contaminants ,
  distribution_id
  )
   VALUES(
  sampling_frequency ,
  complaince_requirements ,
  sampling_comments ,
  notes ,
  contaminants ,
  distribution_id
   )
  RETURNING id
$$;


--
-- TOC entry 293 (class 1255 OID 16495)
-- Name: insertaddressdtl(character varying, character varying, character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertaddressdtl(street_1_val character varying, street_2_val character varying, city_val character varying, state_val character varying, zip_val character varying, coordinate_id_val integer) RETURNS TABLE(address_id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public."address" (
  street_1,
  street_2,
  city,
  state,
  zip ,
  coordinate_id
  
  ) VALUES (
  street_1_val,
  street_2_val,
  city_val,
  state_val,
  zip_val,
  coordinate_id_val
  
  ) RETURNING id
$$;


--
-- TOC entry 361 (class 1255 OID 17750)
-- Name: insertbillingaddressdtl(integer, character, character, character, character, character, character, character, character, character, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertbillingaddressdtl(distribution_id integer, street_1 character, street_2 character, city character, state character, zip character, card_type character, card_name character, card_expiry_month character, card_expiry_year character, card_ccv character, card_no character) RETURNS TABLE(id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public.distribution_billing_address  (
  distribution_id ,
  street_1 ,
  street_2 ,
  city ,
  state ,
  zip ,
  card_type ,
  card_name ,
  card_expiry_month ,
  card_expiry_year ,
  card_ccv ,
  card_no

  )
   VALUES(
  distribution_id ,
  street_1 ,
  street_2 ,
  city ,
  state ,
  zip ,
  card_type ,
  card_name ,
  card_expiry_month ,
  card_expiry_year ,
  card_ccv ,
  card_no

   )
  RETURNING id
$$;


--
-- TOC entry 311 (class 1255 OID 17108)
-- Name: insertboardingadditionalinfo(integer, character varying, character varying, character varying, character varying, character varying, character, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertboardingadditionalinfo(distribution_id integer, pws_location_country character varying, pws_location_town character varying, entry_point_distribution_address character varying, entry_point_distribution_city character varying, entry_point_distribution_state character varying, entry_point_distribution_zip character, water_plant_address character varying, water_plant_city character varying, water_plant_state character varying, water_plant_zip character varying) RETURNS TABLE(address_id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public.boarding_additional_info_location (distribution_id,pws_location_country,pws_location_town,entry_point_distribution_address,entry_point_distribution_city,entry_point_distribution_state,entry_point_distribution_zip,water_plant_address,water_plant_city,water_plant_state,water_plant_zip) VALUES (
distribution_id,pws_location_country,pws_location_town,entry_point_distribution_address,entry_point_distribution_city,entry_point_distribution_state,entry_point_distribution_zip,water_plant_address,water_plant_city,water_plant_state,water_plant_zip) RETURNING id
$$;


--
-- TOC entry 325 (class 1255 OID 17142)
-- Name: insertboardingsamplesitesaddress(integer, numeric, numeric, character, character, character, character, character, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertboardingsamplesitesaddress(distribution_id integer, latitude_val numeric, longitude_val numeric, street_1_val character, street_2_val character, city_val character, state_val character, zip_val character, type_of_sampling_location character, location_samplesite_used character) RETURNS TABLE(sample_sites_address_id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public."sample_sites_address" (
        distribution_id,
 latitude,
 longitude, 
 street_1, 
 street_2, 
 city, 
 state,
 zip,
 type_of_sampling_location ,
 location_samplesite_used 
 ) VALUES (
        distribution_id,
 latitude_val,
 longitude_val,
 street_1_val, 
 street_2_val, 
 city_val, 
 state_val,
 zip_val,
 type_of_sampling_location ,
 location_samplesite_used 
   ) RETURNING id
$$;


--
-- TOC entry 315 (class 1255 OID 17105)
-- Name: insertboardinguser(character varying, character varying, character varying, character varying, character varying, boolean, character varying, character varying, character varying, integer, character varying, character varying, date, date, character, character, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertboardinguser(username_val character varying, firstname_val character varying, middlename_val character varying, lastname_val character varying, encrypted_password_val character varying, active_val boolean, phone_number_val character varying, phone_number_2_val character varying, email_val character varying, license_type_val integer, operator_license_no_val character varying, license_expires_val character varying, started_date_val date, termination_date_val date, license_grade_level character, permission_level character, distribution_system_id integer) RETURNS TABLE(user_id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public."user" (username,firstname,middlename,lastname,encrypted_password, active,phone_number,phone_number_2,email,license_id,operator_license_no,license_expires,started_date,termination_date, distribution_system_id,license_grade_level ,
  permission_level ) VALUES (
  username_val,firstname_val,middlename_val,lastname_val,encrypted_password_val,active_val,phone_number_val,phone_number_2_val,email_val,license_type_val,operator_license_no_val,license_expires_val,started_date_val,termination_date_val,distribution_system_id,license_grade_level,
  permission_level ) RETURNING id
$$;


--
-- TOC entry 245 (class 1255 OID 16496)
-- Name: insertcoordinatedtl(numeric, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertcoordinatedtl(latitude_val numeric, longitude_val numeric) RETURNS TABLE(coordinate_id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public."coordinate" (latitude,longitude) VALUES (
  latitude_val,longitude_val) RETURNING id
$$;


--
-- TOC entry 364 (class 1255 OID 17745)
-- Name: insertdistributionaddress(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertdistributionaddress(distribution_id integer, address_id integer, user_id integer) RETURNS TABLE(id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public."distribution_id_details" (distribution_id,address_id,user_id) VALUES (
 distribution_id,address_id,user_id) RETURNING id
$$;


--
-- TOC entry 297 (class 1255 OID 16934)
-- Name: insertdistributionsystembypwsid(character, character, character, character, character, character, character, character, character, integer, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertdistributionsystembypwsid(pws_ids character, pws_name character, primacy_gency character, "EPA_region" character, primacy_type character, pws_activity character, pws_type character, "GW_SW" character, owner_type character, population integer, pop_cat_desc character, primacy_source character) RETURNS void
    LANGUAGE sql
    AS $$

INSERT INTO  public."distribution_system" 
	
  (
	name ,
	population,
	primacy_gency ,
	"EPA_region" ,
	primacy_type ,
	pws_activity ,
	pws_type ,
	"GW_SW" ,
	owner_type ,
	pop_cat_desc ,
	primacy_source ,
	"PWS_id" 
    )values(
	
	pws_name,
	population,
	primacy_gency,
	"EPA_region",
	primacy_type,
	pws_activity,
	pws_type,
	"GW_SW",
	owner_type,
	pop_cat_desc ,
	primacy_source,
	pws_ids
    )

$$;


--
-- TOC entry 320 (class 1255 OID 17129)
-- Name: insertemployereport(integer, integer, integer, character, character, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertemployereport(distribution_id integer, report_schedule_id integer, user_id integer, job_title character, name character, phone_number character, email character) RETURNS TABLE(id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public."employees_recieve_report" (
     distribution_id ,
     report_schedule_id ,
     user_id ,
     job_title ,
     "name"  ,
     phone_number  ,
     email 

  ) VALUES (

     distribution_id ,
     report_schedule_id ,
     user_id ,
     job_title ,
     "name"  ,
     phone_number  ,
     email 
     
  ) RETURNING id
$$;


--
-- TOC entry 371 (class 1255 OID 17784)
-- Name: insertimage(integer, text, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertimage(address_id integer, image_path text, caption character, image_name character) RETURNS TABLE(id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public.sample_site_images ( 

	address_id ,
	image_path,
	caption,
	image_name
  ) VALUES (
	address_id ,
	image_path,
	caption,
	image_name
  ) RETURNING id
$$;


--
-- TOC entry 294 (class 1255 OID 16497)
-- Name: insertplantaddressdtl(character varying, character varying, character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertplantaddressdtl(street_1_val character varying, street_2_val character varying, city_val character varying, state_val character varying, zip_val character varying, user_id_val integer) RETURNS TABLE(plant_address_id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public."plant_address" 
  (
	street_1,
	street_2,
	city,
	state,
	zip ,
	user_id
  ) VALUES (
	street_1_val,
	street_2_val,
	city_val,
	state_val,
	zip_val,
	user_id_val
  ) RETURNING id
$$;


--
-- TOC entry 369 (class 1255 OID 17742)
-- Name: insertpwsid(character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertpwsid(pws_id character) RETURNS TABLE(id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public.distribution_system ( 
    "PWS_id"
  ) VALUES ( PWS_id
  ) RETURNING id
$$;


--
-- TOC entry 319 (class 1255 OID 17111)
-- Name: insertreportschedule(integer, character varying, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertreportschedule(distribution_id integer, schedule character varying, sanitary_surveys_date_1 date, sanitary_surveys_date_2 date, sanitary_surveys_date_3 date) RETURNS TABLE(id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public."report_schedule" (distribution_id,schedule,sanitary_surveys_date_1 ,sanitary_surveys_date_2 ,sanitary_surveys_date_3) VALUES (distribution_id,schedule,sanitary_surveys_date_1 ,sanitary_surveys_date_2 ,sanitary_surveys_date_3) RETURNING id
$$;


--
-- TOC entry 304 (class 1255 OID 16984)
-- Name: insertrequestcontainer(integer, integer, integer, integer, character, integer, integer, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertrequestcontainer(sampler_id integer, distribution_id integer, address_id integer, containers_amount integer, reagent character, pickup_from_lab integer, deliver integer, phone character) RETURNS TABLE(id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public."request_container" ( 
  sampler_id,
  distribution_id,
  address_id ,
  containers_amount,
  reagent ,
  pickup_from_lab ,
  deliver,phone) VALUES (sampler_id,
  distribution_id,
  address_id ,
  containers_amount,
  reagent ,
  pickup_from_lab ,
  deliver,phone) RETURNING id
$$;


--
-- TOC entry 301 (class 1255 OID 17308)
-- Name: insertsample(integer, integer, integer, character, character, character, boolean, character, character, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertsample(container_id integer, address_id integer, user_id integer, fixture character, temperature character, turbidity character, coliform boolean, chlorine character, ph_level character, delete_type integer, task_id integer) RETURNS TABLE(sample_id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public."samples" (
	container_id ,
	address_id,
	user_id,
	fixture,
	temperature,
	turbidity ,
	coliform ,
	chlorine,
	ph_level,
	delete_type,
	task_id  

  ) VALUES ( 
	container_id ,
	address_id,
	user_id,
	fixture,
	temperature,
	turbidity ,
	coliform ,
	chlorine,
	ph_level,
	delete_type,
	task_id 
 ) RETURNING id
$$;


--
-- TOC entry 363 (class 1255 OID 17781)
-- Name: insertsamplesiteimages(integer, text, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertsamplesiteimages(address_id integer, image_path text, caption character) RETURNS TABLE(id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public.sample_site_images ( 
    
	address_id ,
	image_path ,
	caption 

  ) VALUES ( 
	address_id,
	image_path,
	caption
  ) RETURNING id
$$;


--
-- TOC entry 277 (class 1255 OID 16499)
-- Name: insertsamplesitesaddress(numeric, numeric, character, character, character, character, character, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertsamplesitesaddress(latitude_val numeric, longitude_val numeric, street_1_val character, street_2_val character, city_val character, state_val character, zip_val character, distribution_id integer) RETURNS TABLE(sample_sites_address_id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public."sample_sites_address" (
	latitude,
	longitude, 
	street_1, 
	street_2, 
	city, 
	state,
	zip,
	distribution_id
 ) VALUES (
	latitude_val,
	longitude_val,
	street_1_val, 
	street_2_val, 
	city_val, 
	state_val,
	zip_val,
	distribution_id
   ) RETURNING id
$$;


--
-- TOC entry 281 (class 1255 OID 16500)
-- Name: insertsamplesitesnotes(integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertsamplesitesnotes(sample_sites_address_id_val integer, notes_val text) RETURNS TABLE(sample_sites_notes_id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public."sample_sites_notes" (sample_sites_address_id,notes) VALUES (
  sample_sites_address_id_val,notes_val) RETURNING id
$$;


--
-- TOC entry 278 (class 1255 OID 16501)
-- Name: insertsamplesitesowner(character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertsamplesitesowner(owner_firstname_val character varying, owner_lastname_val character varying, owner_contact_number_val character varying, sample_sites_address_id integer) RETURNS TABLE(owner_id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public."sample_sites_owner" (owner_firstname,owner_lastname,owner_contact_number, sample_sites_address_id) VALUES (
  owner_firstname_val,owner_lastname_val,owner_contact_number_val,sample_sites_address_id) RETURNING id
$$;


--
-- TOC entry 272 (class 1255 OID 16502)
-- Name: insertuseraddress(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertuseraddress(user_id integer, address_id integer) RETURNS TABLE(id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public."user_address" (user_id,address_id) VALUES (
  user_id,address_id) RETURNING id
$$;


--
-- TOC entry 299 (class 1255 OID 16503)
-- Name: insertuserdetails(character varying, character varying, character varying, character varying, character varying, boolean, character varying, character varying, character varying, integer, character varying, character varying, date, date, character, character, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertuserdetails(username_val character varying, firstname_val character varying, middlename_val character varying, lastname_val character varying, encrypted_password_val character varying, active_val boolean, phone_number_val character varying, phone_number_2_val character varying, email_val character varying, license_id_val integer, operator_license_no_val character varying, license_expires_val character varying, started_date_val date, termination_date_val date, license_grade_level character, permission_level character, distribution_system_id integer) RETURNS TABLE(user_id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public."user" (
	username,
	firstname,
	middlename,
	lastname,
	encrypted_password, 
	active,
	phone_number,
	phone_number_2,
	email,
	license_id,
	operator_license_no,
	license_expires,
	started_date,
	termination_date,
	distribution_system_id,
	license_grade_level ,
	permission_level
   ) VALUES (
	username_val,
	firstname_val,
	middlename_val,
	lastname_val,
	encrypted_password_val,
	active_val,
	phone_number_val,
	phone_number_2_val,
	email_val,
	license_id_val,
	operator_license_no_val,
	license_expires_val,
	started_date_val,
	termination_date_val,
	distribution_system_id,
	license_grade_level,
	permission_level
   ) RETURNING id
$$;


--
-- TOC entry 279 (class 1255 OID 16504)
-- Name: insertuserdistributionroles(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insertuserdistributionroles(user_id integer, db_system_id integer, roles_id integer) RETURNS TABLE(id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public."user_distribution_roles" (
	user_id,
	db_system_id,
	roles_id
  ) VALUES (
	user_id  ,
	db_system_id  
	,roles_id 
  ) RETURNING id
$$;


--
-- TOC entry 280 (class 1255 OID 16505)
-- Name: quickreply(integer, integer, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION quickreply(sender_id_val integer, message_type_val integer, recipient_id_val integer, message_val character varying, subject_val character varying) RETURNS TABLE(alert_id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public.alert (

	sender_id,
	message_type,
	recipient_id,
	message,subject
  ) VALUES (
	sender_id_val,
	message_type_val,
	recipient_id_val,
	message_val,
	subject_val
  ) RETURNING id
$$;


--
-- TOC entry 273 (class 1255 OID 16506)
-- Name: resetpassword(integer, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION resetpassword(user_id integer, password character) RETURNS void
    LANGUAGE sql
    AS $$
          update public."user" set encrypted_password=resetPassword.password  where id=resetPassword.user_id;
$$;


--
-- TOC entry 274 (class 1255 OID 16507)
-- Name: savedraft(integer, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION savedraft(sender_id_val integer, message_type_val integer, message_val character varying, subject_val character varying) RETURNS TABLE(alert_id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public.alert (sender_id,message_type,message,subject) VALUES (
  sender_id_val,message_type_val,message_val,subject_val) RETURNING id
$$;


--
-- TOC entry 346 (class 1255 OID 17468)
-- Name: savereport(boolean, boolean, character, integer, boolean, boolean, boolean, date, date, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION savereport(download boolean, send_to_email boolean, email character, user_id integer, daily boolean, weekly boolean, monthly boolean, from_date date, to_date date, created_by integer) RETURNS TABLE(id integer)
    LANGUAGE sql
    AS $$
	INSERT INTO reports (
	download  ,
	send_to_email  ,
	email  ,
	user_id  ,
	daily  ,
	weekly  ,
	monthly  ,
	from_date ,
	to_date ,
	created_by  
	) VALUES (
	download  ,
	send_to_email  ,
	email  ,
	user_id  ,
	daily  ,
	weekly  ,
	monthly  ,
	from_date ,
	to_date ,
	created_by 
	) RETURNING id
$$;


--
-- TOC entry 275 (class 1255 OID 16508)
-- Name: sendalert(integer, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION sendalert(sender_id integer, message_type integer, message_val character varying, subject_val character varying) RETURNS TABLE(alert_id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public.alert (sender_id,message_type,message,subject) VALUES (
  sender_id,message_type,message_val,subject_val) RETURNING id
$$;


--
-- TOC entry 276 (class 1255 OID 16509)
-- Name: sendalert(integer, integer, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION sendalert(sender_id integer, message_type integer, recipient_id integer, message_val character varying, subject_val character varying) RETURNS TABLE(alert_id integer)
    LANGUAGE sql
    AS $$
  INSERT INTO public.alert (sender_id,message_type,recipient_id,message,subject) VALUES (
  sender_id,message_type,recipient_id,message_val,subject_val) RETURNING id
$$;


--
-- TOC entry 300 (class 1255 OID 16510)
-- Name: sendalertdraft(integer, integer, integer, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION sendalertdraft(alert_id integer, message_type integer, recipient_id integer, subject character, message character) RETURNS void
    LANGUAGE sql
    AS $$
 
	update public.alert
	set message_type = sendalertdraft.message_type,
	recipient_id=sendalertdraft.recipient_id,
	subject = sendalertdraft.subject, 
	message=sendalertdraft.message
	where id=sendalertdraft.alert_id;
                 
$$;


--
-- TOC entry 260 (class 1255 OID 16511)
-- Name: softdeletesample(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION softdeletesample(sample_id integer, delete_type integer) RETURNS void
    LANGUAGE sql
    AS $$

          update samples  SET  delete_type=softdeletesample.delete_type
           where id=softdeletesample.sample_id ;
                 
$$;


--
-- TOC entry 306 (class 1255 OID 17062)
-- Name: updateaccountinfodtl(integer, integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character, character, character, character, character, character, character, character, character, character, character, character, character, character, character, character, numeric, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updateaccountinfodtl(user_id integer, coordinateid integer, address_id integer, billing_id integer, firstname_val character varying, middlename_val character varying, lastname_val character varying, phone_number_val character varying, phone_number_2_val character varying, email_val character varying, license_id_val integer, operator_license_no_val character varying, license_expires_val character varying, street_1_plant_val character, street_2_plant_val character, city_plant_val character, state_plant_val character, zip_val character, street_1_add_val character, street_2_add_val character, city_add_val character, state_add_val character, zip_add_val character, card_type character, card_name character, card_expiry_month character, card_expiry_year character, card_ccv character, card_no character, latitude_val numeric, longitude_val numeric) RETURNS void
    LANGUAGE sql
    AS $$
          update public."user" set 
          firstname=updateaccountinfodtl.firstname_val,middlename=updateaccountinfodtl.middlename_val,lastname=updateaccountinfodtl.lastname_val,
         phone_number=updateaccountinfodtl.phone_number_val,phone_number_2=updateaccountinfodtl.phone_number_2_val,email=updateaccountinfodtl.email_val,
          license_id=updateaccountinfodtl.license_id_val,operator_license_no=updateaccountinfodtl.operator_license_no_val,license_expires=updateaccountinfodtl.license_expires_val,updated_at=now()
          where id=updateaccountinfodtl.user_id;
          
          update public."distribution_billing_address" set 
          street_1=updateaccountinfodtl.street_1_plant_val,street_2=updateaccountinfodtl.street_2_plant_val,city=updateaccountinfodtl.city_plant_val,state=updateaccountinfodtl.state_plant_val,zip=updateaccountinfodtl.zip_val,card_type=updateaccountinfodtl.card_type,card_name=updateaccountinfodtl.card_name,card_expiry_month=updateaccountinfodtl.card_expiry_month,card_expiry_year=updateaccountinfodtl.card_expiry_year,card_ccv=updateaccountinfodtl.card_ccv,card_no=updateaccountinfodtl.card_no
          where id=updateaccountinfodtl.billing_id;   

          update public."address" set 
          street_1=updateaccountinfodtl.street_1_add_val,street_2=updateaccountinfodtl.street_2_add_val,city=updateaccountinfodtl.city_add_val,state=updateaccountinfodtl.state_add_val,zip=updateaccountinfodtl.zip_add_val
          where id=updateaccountinfodtl.address_id;  

   update public."coordinate" set 
          latitude=updateaccountinfodtl.latitude_val,longitude=updateaccountinfodtl.longitude_val
          where id=updateaccountinfodtl.coordinateid;   
        
$$;


--
-- TOC entry 303 (class 1255 OID 16983)
-- Name: updatebillingdaddressdtl(integer, character, character, character, character, character, character, character, character, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updatebillingdaddressdtl(billing_id integer, street_1 character, street_2 character, city character, state character, zip character, card_name character, card_type character, card_expiry_month character, card_expiry_year character, card_no character) RETURNS void
    LANGUAGE sql
    AS $$
 UPDATE  public.distribution_billing_address SET street_1=updatebillingdaddressDtl.street_1, street_2=updatebillingdaddressDtl.street_2, city=updatebillingdaddressDtl.city, state=updatebillingdaddressDtl.state, zip=updatebillingdaddressDtl.zip, card_name=updatebillingdaddressDtl.card_name,card_type=updatebillingdaddressDtl.card_type, card_expiry_month=updatebillingdaddressDtl.card_expiry_month, card_expiry_year=updatebillingdaddressDtl.card_expiry_year, card_no=updatebillingdaddressDtl.card_no  where id = updatebillingdaddressDtl.billing_id;
$$;


--
-- TOC entry 295 (class 1255 OID 16930)
-- Name: updatebillingdaddressdtl(integer, character, character, character, character, character, character, character, character, character, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updatebillingdaddressdtl(billing_id integer, street_1 character, street_2 character, city character, state character, zip character, card_name character, card_type character, card_expiry_month character, card_expiry_year character, card_ccv character, card_no character) RETURNS void
    LANGUAGE sql
    AS $$
 UPDATE  public.distribution_billing_address SET street_1=updatebillingdaddressDtl.street_1, street_2=updatebillingdaddressDtl.street_2, city=updatebillingdaddressDtl.city, state=updatebillingdaddressDtl.state, zip=updatebillingdaddressDtl.zip, card_name=updatebillingdaddressDtl.card_name,card_type=updatebillingdaddressDtl.card_type, card_expiry_month=updatebillingdaddressDtl.card_expiry_month, card_expiry_year=updatebillingdaddressDtl.card_expiry_year, card_ccv=updatebillingdaddressDtl.card_ccv, card_no=updatebillingdaddressDtl.card_no where id = updatebillingdaddressDtl.billing_id;
$$;


--
-- TOC entry 317 (class 1255 OID 17109)
-- Name: updateboardingadditionalinfo(integer, character varying, character varying, character varying, character varying, character varying, character, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updateboardingadditionalinfo(boarding_additional_info_id integer, pws_location_country character varying, pws_location_town character varying, entry_point_distribution_address character varying, entry_point_distribution_city character varying, entry_point_distribution_state character varying, entry_point_distribution_zip character, water_plant_address character varying, water_plant_city character varying, water_plant_state character varying, water_plant_zip character varying) RETURNS void
    LANGUAGE sql
    AS $$
 UPDATE  boarding_additional_info_location  SET pws_location_country=updateboardingadditionalinfo.pws_location_country,pws_location_town=updateboardingadditionalinfo.pws_location_town,entry_point_distribution_address=updateboardingadditionalinfo.entry_point_distribution_address,entry_point_distribution_city=updateboardingadditionalinfo.entry_point_distribution_city,entry_point_distribution_state=updateboardingadditionalinfo.entry_point_distribution_state,entry_point_distribution_zip=updateboardingadditionalinfo.entry_point_distribution_zip,water_plant_address=updateboardingadditionalinfo.water_plant_address,water_plant_city=updateboardingadditionalinfo.water_plant_city,water_plant_state=updateboardingadditionalinfo.water_plant_state,water_plant_zip=updateboardingadditionalinfo.water_plant_zip,updated_at=now()  where distribution_id=updateboardingadditionalinfo.boarding_additional_info_id
$$;


--
-- TOC entry 305 (class 1255 OID 16967)
-- Name: updateboardinguserdtl(integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character, character, character, character, character, numeric, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updateboardinguserdtl(user_id integer, coordinateid integer, address_id integer, firstname_val character varying, lastname_val character varying, operator_license_no_val character varying, phone_number_val character varying, email character varying, license_expires_val character varying, license_id_val integer, street_1_add_val character, street_2_add_val character, city_add_val character, state_add_val character, zip_add_val character, latitude_val numeric, longitude_val numeric) RETURNS void
    LANGUAGE sql
    AS $$
          update public."user" set 
   firstname=updateboardinguserdtl.firstname_val,
   lastname=updateboardinguserdtl.lastname_val,
          phone_number=updateboardinguserdtl.phone_number_val,
          license_id=updateboardinguserdtl.license_id_val,
          operator_license_no=updateboardinguserdtl.operator_license_no_val,
          license_expires=updateboardinguserdtl.license_expires_val,
          email=updateboardinguserdtl.email
          where id=updateboardinguserdtl.user_id;

          update public."address" set 
          street_1=updateboardinguserdtl.street_1_add_val,
          street_2=updateboardinguserdtl.street_2_add_val,
          city=updateboardinguserdtl.city_add_val,
          state=updateboardinguserdtl.state_add_val,
          zip=updateboardinguserdtl.zip_add_val
          where id=updateboardinguserdtl.address_id;  

          update public."coordinate" set 
          latitude=updateboardinguserdtl.latitude_val,
          longitude=updateboardinguserdtl.longitude_val
          where id=updateboardinguserdtl.coordinateId;   

            
$$;


--
-- TOC entry 309 (class 1255 OID 17065)
-- Name: updatedistributionsystem(integer, integer, integer, integer, character, character, character, character, character, character, character, character, character, character, character, character, integer, character, character, character, character, character, character, character, character, character, character, numeric, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updatedistributionsystem(user_id integer, distribution_id integer, address_id integer, coordinate_id integer, firstname character, lastname character, operator_license_no character, email character, phone_number character, username character, street_1 character, street_2 character, city character, state character, zip character, name character, population integer, pws_id character, primacy_gency character, epa_region character, primacy_type character, pws_activity character, pws_type character, gw_sw character, owner_type character, pop_cat_desc character, primacy_source character, latitude numeric, longitude numeric) RETURNS void
    LANGUAGE sql
    AS $$
          update public."user" set  firstname=updatedistributionsystem.firstname   ,username=updatedistributionsystem.username,
          lastname=updatedistributionsystem.lastname,  operator_license_no=updatedistributionsystem.operator_license_no, 
           email=updatedistributionsystem.email,phone_number=updatedistributionsystem.phone_number 
          where id=updatedistributionsystem.user_id;
          
          update public."address" set street_1=updatedistributionsystem.street_1, street_2=updatedistributionsystem.street_2,city=updatedistributionsystem.city,state=updatedistributionsystem.state,zip=updatedistributionsystem."zip"
          where id=updatedistributionsystem.address_id;

          update public."distribution_system" set name=updatedistributionsystem.name,population=updatedistributionsystem.population,
    "PWS_id"=updatedistributionsystem.PWS_id,primacy_gency=updatedistributionsystem.primacy_gency,"EPA_region"=updatedistributionsystem.EPA_region,primacy_type=updatedistributionsystem.primacy_type,
    "pws_activity"=updatedistributionsystem.pws_activity,pws_type=updatedistributionsystem.pws_type,"GW_SW"=updatedistributionsystem.GW_SW,owner_type=updatedistributionsystem.owner_type,pop_cat_desc=updatedistributionsystem.pop_cat_desc,primacy_source=updatedistributionsystem.primacy_source
           where id=updatedistributionsystem.distribution_id;
                 
$$;


--
-- TOC entry 380 (class 1255 OID 17752)
-- Name: updatedistributionsystembypwsid(integer, character, character, character, character, character, character, character, character, character, integer, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updatedistributionsystembypwsid(userid integer, pws_ids character, pws_name character, primacy_gency character, "EPA_region" character, primacy_type character, pws_activity character, pws_type character, "GW_SW" character, owner_type character, population integer, pop_cat_desc character, primacy_source character) RETURNS void
    LANGUAGE sql
    AS $$

         
	update public.distribution_system SET 

	"name"=updatedistributionsystembypwsid.pws_name,
	primacy_gency=updatedistributionsystembypwsid.primacy_gency,
	"EPA_region"=updatedistributionsystembypwsid."EPA_region",
	primacy_type=updatedistributionsystembypwsid.primacy_type,
	pws_activity=updatedistributionsystembypwsid.pws_activity,
	pws_type=updatedistributionsystembypwsid.pws_type,
	"GW_SW"=updatedistributionsystembypwsid."GW_SW",
	owner_type=updatedistributionsystembypwsid.owner_type,
	population=updatedistributionsystembypwsid.population,
	pop_cat_desc=updatedistributionsystembypwsid.pop_cat_desc,
	primacy_source=updatedistributionsystembypwsid.primacy_source

	where  distribution_system."PWS_id"=updatedistributionsystembypwsid.pws_ids;


$$;


--
-- TOC entry 282 (class 1255 OID 16514)
-- Name: updatedraftalert(integer, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updatedraftalert(alert_id integer, subject character, message character) RETURNS void
    LANGUAGE sql
    AS $$

          
          update public.alert set subject = updatedraftalert.subject, message=updatedraftalert.message
          where id=updatedraftalert.alert_id;
                 
$$;


--
-- TOC entry 348 (class 1255 OID 17496)
-- Name: updateemergency(integer, integer, integer, integer, integer, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updateemergency(note_id integer, task_id integer, assign_to integer, emergency_type integer, total_sample integer, comments character, note character) RETURNS void
    LANGUAGE sql
    AS $$

          
	update task set 
	user_id =updateEmergency.assign_to,
	emergency_type =updateEmergency.emergency_type,
	total_sample =updateEmergency.total_sample,
	comments =updateEmergency.comments
	where id=updateEmergency.task_id;

	update sample_sites_notes set 
	notes =updateEmergency.note
	where id=updateEmergency.note_id;
          
$$;


--
-- TOC entry 372 (class 1255 OID 17797)
-- Name: updatelabtechcontainerresultsfail(integer, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updatelabtechcontainerresultsfail(container_id integer, status_id integer, reasons_for_failure text) RETURNS void
    LANGUAGE sql
    AS $$

          
          update containers set status=updateLabTechContainerResultsFail.status_id,  reasons_for_failure=updateLabTechContainerResultsFail.reasons_for_failure
          where id=updateLabTechContainerResultsFail.container_id;
                 
$$;


--
-- TOC entry 373 (class 1255 OID 17796)
-- Name: updatelabtechcontainerresultspass(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updatelabtechcontainerresultspass(container_id integer, status_id integer) RETURNS void
    LANGUAGE sql
    AS $$

          
          update containers set status=updateLabTechContainerResultsPass.status_id
          where id=updateLabTechContainerResultsPass.container_id;
                 
$$;


--
-- TOC entry 286 (class 1255 OID 16515)
-- Name: updateownersampler(integer, integer, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updateownersampler(sample_sites_address_id integer, owner_id integer, owner_firstname_val character varying, owner_lastname_val character varying, owner_contact_number_val character varying) RETURNS void
    LANGUAGE sql
    AS $$

          update public."sample_sites_owner" set owner_firstname=updateownersampler.owner_firstname_val,owner_lastname=updateownersampler.owner_lastname_val,owner_contact_number=updateownersampler.owner_contact_number_val
           where id=updateownersampler.owner_id  AND sample_sites_address_id=updateownersampler.sample_sites_address_id ;
                 
$$;


--
-- TOC entry 356 (class 1255 OID 17809)
-- Name: updatereceivedcontainerreject(integer, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updatereceivedcontainerreject(container_id integer, status_id integer, reasons_for_failure text) RETURNS void
    LANGUAGE sql
    AS $$

          
          update containers set status=updateReceivedcontainerReject.status_id,  reasons_for_failure=updateReceivedcontainerReject.reasons_for_failure
          where id=updateReceivedcontainerReject.container_id;
                 
$$;


--
-- TOC entry 370 (class 1255 OID 17744)
-- Name: updaterequestcontaineramount(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updaterequestcontaineramount(request_container_id integer) RETURNS void
    LANGUAGE sql
    AS $$ 
update public.request_container set containers_amount = (select containers_amount from request_container where id=updaterequestcontaineramount.request_container_id)-1, updated_at = now()
where id=updaterequestcontaineramount.request_container_id;
$$;


--
-- TOC entry 308 (class 1255 OID 17064)
-- Name: updatesamplesite(integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, numeric, numeric, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updatesamplesite(sample_sites_address_id integer, sample_sites_owner_id integer, sample_sites_notes_id integer, street_1_val character varying, street_2_val character varying, city_val character varying, state_val character varying, zip_val character varying, owner_firstname_val character varying, owner_lastname_val character varying, owner_contact_number_val character varying, latitude_val numeric, longitude_val numeric, notes text) RETURNS void
    LANGUAGE sql
    AS $$
          update public."sample_sites_address" set  street_1=updatesamplesite.street_1_val,street_2=updatesamplesite.street_2_val,city=    updatesamplesite.city_val,state=updatesamplesite.state_val,zip=updatesamplesite.zip_val,latitude=updatesamplesite.latitude_val,longitude=updatesamplesite.longitude_val
         where id=updatesamplesite.sample_sites_address_id;
          
          update public."sample_sites_notes" set notes=updatesamplesite.notes
          where id=updatesamplesite.sample_sites_notes_id;

          update public."sample_sites_owner" set owner_firstname=updatesamplesite.owner_firstname_val,owner_lastname=updatesamplesite.owner_lastname_val,owner_contact_number=updatesamplesite.owner_contact_number_val
           where id=updatesamplesite.sample_sites_owner_id;
                 
$$;


--
-- TOC entry 338 (class 1255 OID 17306)
-- Name: updatetask(integer, integer, integer, integer, character, character, integer, integer, integer, boolean, boolean, boolean, boolean, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updatetask(task_id integer, user_id integer, assign_by integer, address_id integer, assign_date character, schedule_date character, total_sample integer, sample_required integer, status integer, coliform boolean, copper boolean, metals boolean, emergency_sample boolean, phone_no character) RETURNS void
    LANGUAGE sql
    AS $$ 

 UPDATE  task  SET

	user_id=updateTask.user_id , 
	assign_by=updateTask.assign_by ,
	address_id=updateTask.address_id ,
	assign_date=updateTask.assign_date ,
	schedule_date=updateTask.schedule_date , 
	total_sample=updateTask.total_sample , 
	sample_required=updateTask.sample_required ,
	status=updateTask.status, 
	coliform=updateTask.coliform , 
	copper=updateTask.copper ,
	metals=updateTask.metals , 
	emergency_sample=updateTask.emergency_sample , 
	phone_no=updateTask.phone_no 
	where id=updateTask.task_id
	
 $$;


--
-- TOC entry 337 (class 1255 OID 17305)
-- Name: updatetaskisdelete(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updatetaskisdelete(task_id integer, is_delete integer) RETURNS void
    LANGUAGE sql
    AS $$

          
          update public.task  set is_delete=updateTaskIsDelete.is_delete
          where id=updateTaskIsDelete.task_id;
                 
$$;


--
-- TOC entry 283 (class 1255 OID 16517)
-- Name: updatetoken(integer, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updatetoken(user_id integer, access_token character, token_expire_time character) RETURNS void
    LANGUAGE sql
    AS $$

          
          update public."user" set access_token=updateToken.access_token, token_expire_time=updateToken.token_expire_time
          where id=updateToken.user_id;
                 
$$;


--
-- TOC entry 284 (class 1255 OID 16518)
-- Name: updateuseractive(integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updateuseractive(user_id integer, active boolean) RETURNS void
    LANGUAGE sql
    AS $$

          
          update public."user" set active = updateuseractive.active
          where id=updateuseractive.user_id;
                 
$$;


--
-- TOC entry 285 (class 1255 OID 16519)
-- Name: updateuserattempts(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updateuserattempts(user_id integer, failed_attempts integer) RETURNS void
    LANGUAGE sql
    AS $$

          
          update public."user" set failed_attempts = updateuserattempts.failed_attempts
          where id=updateuserattempts.user_id;
                 
$$;


--
-- TOC entry 314 (class 1255 OID 17075)
-- Name: updateuserdtl(integer, integer, integer, integer, character varying, character varying, character varying, character varying, boolean, character varying, character varying, character varying, integer, character varying, date, date, date, character, character, character, character, character, character, character, character, character, character, numeric, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updateuserdtl(user_id integer, coordinateid integer, address_id integer, plant_address_id integer, firstname_val character varying, middlename_val character varying, lastname_val character varying, username character varying, active_val boolean, phone_number_val character varying, phone_number_2_val character varying, email_val character varying, license_id_val integer, operator_license_no_val character varying, license_expires_val date, started_date_val date, termination_date_val date, street_1_plant_val character, street_2_plant_val character, city_plant_val character, state_plant_val character, zip_val character, street_1_add_val character, street_2_add_val character, city_add_val character, state_add_val character, zip_add_val character, latitude_val numeric, longitude_val numeric) RETURNS void
    LANGUAGE sql
    AS $$
          update public."user" set 
   firstname=updateUserDtl.firstname_val,middlename=updateUserDtl.middlename_val,lastname=updateUserDtl.lastname_val,username=updateUserDtl.username,
          active=updateUserDtl.active_val,phone_number=updateUserDtl.phone_number_val,phone_number_2=updateUserDtl.phone_number_2_val,email=updateUserDtl.email_val,
          license_id=updateUserDtl.license_id_val,operator_license_no=updateUserDtl.operator_license_no_val,license_expires=updateUserDtl.license_expires_val,started_date=updateUserDtl.started_date_val,termination_date=updateUserDtl.termination_date_val,updated_at=now()
          where id=updateUserDtl.user_id;
         
          update public."plant_address" set 
          street_1=updateUserDtl.street_1_plant_val,street_2=updateUserDtl.street_2_plant_val,city=updateUserDtl.city_plant_val,state=updateUserDtl.state_plant_val,zip=updateUserDtl.zip_val
          where id=updateUserDtl.plant_address_id;   

          update public."address" set 
          street_1=updateUserDtl.street_1_add_val,street_2=updateUserDtl.street_2_add_val,city=updateUserDtl.city_add_val,state=updateUserDtl.state_add_val,zip=updateUserDtl.zip_add_val
          where id=updateUserDtl.address_id;  

   update public."coordinate" set 
          latitude=updateUserDtl.latitude_val,longitude=updateUserDtl.longitude_val
          where id=updateUserDtl.coordinateid;   

            
$$;


--
-- TOC entry 335 (class 1255 OID 17297)
-- Name: updateuserloggedin(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updateuserloggedin(user_id integer) RETURNS void
    LANGUAGE sql
    AS $$

          
          update public."user" set logged_in = TRUE
          where id=updateuserLoggedIn.user_id;
                 
$$;


--
-- TOC entry 362 (class 1255 OID 17775)
-- Name: updateuserloggedout(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION updateuserloggedout(user_id integer) RETURNS void
    LANGUAGE sql
    AS $$

          
          update public."user" set logged_in = FALSE,  access_token=null,  failed_attempts=0
          where id=updateuserloggedOut.user_id;
                 
$$;


--
-- TOC entry 185 (class 1259 OID 16385)
-- Name: address_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 208 (class 1259 OID 16522)
-- Name: address; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE address (
    id integer DEFAULT nextval('address_id_seq'::regclass) NOT NULL,
    coordinate_id integer,
    street_1 character varying NOT NULL,
    street_2 character varying,
    city character varying NOT NULL,
    state character varying NOT NULL,
    zip character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 187 (class 1259 OID 16397)
-- Name: alert_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE alert_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 209 (class 1259 OID 16531)
-- Name: alert; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE alert (
    id integer DEFAULT nextval('alert_id_seq'::regclass) NOT NULL,
    sender_id integer NOT NULL,
    message_type integer NOT NULL,
    recipient_id integer,
    message character varying NOT NULL,
    acknowledged_at timestamp without time zone DEFAULT now(),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    subject character varying
);


--
-- TOC entry 210 (class 1259 OID 16541)
-- Name: billing_address; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE billing_address (
    id integer DEFAULT nextval('address_id_seq'::regclass) NOT NULL,
    user_id integer,
    street_1 character varying NOT NULL,
    street_2 character varying,
    city character varying NOT NULL,
    state character varying NOT NULL,
    zip character varying NOT NULL,
    card_type character varying,
    card_name character varying,
    card_expiry_month character varying,
    card_expiry_year character varying,
    card_ccv character varying,
    card_no character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    coordinate_id integer
);


--
-- TOC entry 188 (class 1259 OID 16399)
-- Name: billing_address_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE billing_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 233 (class 1259 OID 17081)
-- Name: boarding_additional_info_location_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE boarding_additional_info_location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 234 (class 1259 OID 17083)
-- Name: boarding_additional_info_location; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE boarding_additional_info_location (
    id integer DEFAULT nextval('boarding_additional_info_location_id_seq'::regclass) NOT NULL,
    distribution_id integer NOT NULL,
    pws_location_country character varying,
    pws_location_town character varying,
    entry_point_distribution_address character varying,
    entry_point_distribution_city character varying,
    entry_point_distribution_state character varying,
    entry_point_distribution_zip character varying,
    water_plant_address character varying,
    water_plant_city character varying,
    water_plant_state character varying,
    water_plant_zip character varying,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 189 (class 1259 OID 16401)
-- Name: containers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE containers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 211 (class 1259 OID 16550)
-- Name: containers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE containers (
    id integer DEFAULT nextval('containers_id_seq'::regclass) NOT NULL,
    assigned_to integer,
    assigned_by integer,
    date_issued timestamp without time zone,
    time_issued timestamp without time zone,
    disposer_id integer,
    disposal_reason character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    time_used timestamp without time zone DEFAULT now() NOT NULL,
    "QR_code" character varying,
    "bar_Code" character varying,
    "scan_via_QR" boolean,
    scan_via_bar boolean,
    status integer DEFAULT 0 NOT NULL,
    incubation_start timestamp without time zone,
    incubation_end timestamp without time zone,
    comments character varying,
    distribution_id integer NOT NULL,
    reasons_for_failure text
);


--
-- TOC entry 2771 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN containers.assigned_to; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN containers.assigned_to IS 'sampler ids';


--
-- TOC entry 2772 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN containers.assigned_by; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN containers.assigned_by IS 'labtech';


--
-- TOC entry 2773 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN containers.date_issued; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN containers.date_issued IS 'labtech assigned when  scan';


--
-- TOC entry 2774 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN containers.disposer_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN containers.disposer_id IS 'labtech';


--
-- TOC entry 186 (class 1259 OID 16395)
-- Name: contaminants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contaminants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 212 (class 1259 OID 16561)
-- Name: contaminants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contaminants (
    id integer DEFAULT nextval('contaminants_id_seq'::regclass) NOT NULL,
    contaminant character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 190 (class 1259 OID 16403)
-- Name: coordinate_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE coordinate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 213 (class 1259 OID 16570)
-- Name: coordinate; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE coordinate (
    id integer DEFAULT nextval('coordinate_id_seq'::regclass) NOT NULL,
    latitude numeric(10,7) DEFAULT 0.0 NOT NULL,
    longitude numeric(10,7) DEFAULT 0.0 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 237 (class 1259 OID 17202)
-- Name: distribution_additional_monitering_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE distribution_additional_monitering_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 238 (class 1259 OID 17204)
-- Name: distribution_additional_monitering; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE distribution_additional_monitering (
    id integer DEFAULT nextval('distribution_additional_monitering_id_seq'::regclass) NOT NULL,
    sampling_frequency character varying,
    complaince_requirements character varying,
    sampling_comments character varying,
    notes character varying,
    contaminants character varying,
    distribution_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 229 (class 1259 OID 16935)
-- Name: distribution_billing_address_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE distribution_billing_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 230 (class 1259 OID 16938)
-- Name: distribution_billing_address; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE distribution_billing_address (
    id integer DEFAULT nextval('distribution_billing_address_id_seq'::regclass) NOT NULL,
    distribution_id integer,
    street_1 character varying NOT NULL,
    street_2 character varying,
    city character varying NOT NULL,
    state character varying NOT NULL,
    zip character varying NOT NULL,
    card_type character varying,
    card_name character varying,
    card_expiry_month character varying,
    card_expiry_year character varying,
    card_ccv character varying,
    card_no character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    coordinate_id integer,
    billing_cycle character varying,
    public_water_system character varying
);


--
-- TOC entry 191 (class 1259 OID 16405)
-- Name: distribution_id_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE distribution_id_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 214 (class 1259 OID 16588)
-- Name: distribution_id_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE distribution_id_details (
    id integer DEFAULT nextval('distribution_id_details_id_seq'::regclass) NOT NULL,
    distribution_id integer NOT NULL,
    address_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 240 (class 1259 OID 17390)
-- Name: emergency_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE emergency_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 239 (class 1259 OID 17368)
-- Name: emergency_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE emergency_type (
    id integer DEFAULT nextval('emergency_type_id_seq'::regclass) NOT NULL,
    emergency_type character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 235 (class 1259 OID 17116)
-- Name: employees_recieve_report_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE employees_recieve_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 236 (class 1259 OID 17118)
-- Name: employees_recieve_report; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE employees_recieve_report (
    id integer DEFAULT nextval('employees_recieve_report_id_seq'::regclass) NOT NULL,
    report_schedule_id integer NOT NULL,
    user_id integer NOT NULL,
    distribution_id integer NOT NULL,
    job_title character varying,
    name character varying,
    phone_number character varying,
    email character varying,
    crested_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 193 (class 1259 OID 16409)
-- Name: lience_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lience_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 216 (class 1259 OID 16606)
-- Name: lience; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE lience (
    id integer DEFAULT nextval('lience_id_seq'::regclass) NOT NULL,
    type character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 194 (class 1259 OID 16411)
-- Name: plant_address_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE plant_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 217 (class 1259 OID 16615)
-- Name: plant_address; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE plant_address (
    id integer DEFAULT nextval('plant_address_id_seq'::regclass) NOT NULL,
    user_id integer,
    street_1 character varying NOT NULL,
    street_2 character varying,
    city character varying NOT NULL,
    state character varying NOT NULL,
    zip character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 195 (class 1259 OID 16413)
-- Name: report_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE report_schedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 218 (class 1259 OID 16624)
-- Name: report_schedule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE report_schedule (
    id integer DEFAULT nextval('report_schedule_id_seq'::regclass) NOT NULL,
    schedule character varying,
    sanitary_surveys_date_1 date,
    sanitary_surveys_date_2 date,
    sanitary_surveys_date_3 date,
    schedule_daily integer DEFAULT 1 NOT NULL,
    schedule_weekly integer DEFAULT 1 NOT NULL,
    schedule_monthly integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    distribution_id integer NOT NULL,
    user_id integer
);


--
-- TOC entry 242 (class 1259 OID 17463)
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 241 (class 1259 OID 17409)
-- Name: reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE reports (
    id integer DEFAULT nextval('reports_id_seq'::regclass) NOT NULL,
    download boolean DEFAULT false NOT NULL,
    send_to_email boolean DEFAULT false NOT NULL,
    email character varying,
    user_id integer NOT NULL,
    daily boolean DEFAULT false NOT NULL,
    weekly boolean DEFAULT false NOT NULL,
    monthly boolean DEFAULT false NOT NULL,
    from_date date,
    to_date date,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 196 (class 1259 OID 16415)
-- Name: request_container_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE request_container_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 219 (class 1259 OID 16636)
-- Name: request_container; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE request_container (
    id integer DEFAULT nextval('request_container_id_seq'::regclass) NOT NULL,
    sampler_id integer NOT NULL,
    distribution_id integer NOT NULL,
    address_id integer NOT NULL,
    containers_amount integer,
    reagent character varying,
    pickup_from_lab integer,
    deliver integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    phone character varying
);


--
-- TOC entry 197 (class 1259 OID 16417)
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 232 (class 1259 OID 16968)
-- Name: role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE role (
    id integer DEFAULT nextval('role_id_seq'::regclass) NOT NULL,
    name character varying DEFAULT 'Unspecified'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    nickname character varying,
    "position" integer DEFAULT 0 NOT NULL,
    menu_icon character varying
);


--
-- TOC entry 198 (class 1259 OID 16421)
-- Name: sample_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 231 (class 1259 OID 16965)
-- Name: sample_site_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sample_site_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 220 (class 1259 OID 16671)
-- Name: sample_site_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sample_site_images (
    id integer DEFAULT nextval('sample_site_images_id_seq'::regclass) NOT NULL,
    address_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    image_path text,
    caption character varying,
    image_name character varying
);


--
-- TOC entry 199 (class 1259 OID 16423)
-- Name: sample_sites_address_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sample_sites_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 221 (class 1259 OID 16679)
-- Name: sample_sites_address; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sample_sites_address (
    id integer DEFAULT nextval('sample_sites_address_id_seq'::regclass) NOT NULL,
    latitude numeric(10,7) DEFAULT 0.0 NOT NULL,
    longitude numeric(10,7) DEFAULT 0.0 NOT NULL,
    street_1 character varying,
    street_2 character varying,
    city character varying,
    state character varying,
    zip character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    type_of_sampling_location character varying,
    location_samplesite_used character varying,
    distribution_id integer
);


--
-- TOC entry 200 (class 1259 OID 16425)
-- Name: sample_sites_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sample_sites_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 222 (class 1259 OID 16690)
-- Name: sample_sites_notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sample_sites_notes (
    id integer DEFAULT nextval('sample_sites_notes_id_seq'::regclass) NOT NULL,
    sample_sites_address_id integer NOT NULL,
    notes text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 201 (class 1259 OID 16428)
-- Name: sample_sites_owner_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sample_sites_owner_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 223 (class 1259 OID 16699)
-- Name: sample_sites_owner; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sample_sites_owner (
    id integer DEFAULT nextval('sample_sites_owner_id_seq'::regclass) NOT NULL,
    owner_firstname character varying,
    owner_lastname character varying,
    owner_contact_number character varying,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    sample_sites_address_id integer NOT NULL
);


--
-- TOC entry 224 (class 1259 OID 16708)
-- Name: samples; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE samples (
    id integer DEFAULT nextval('sample_id_seq'::regclass) NOT NULL,
    container_id integer NOT NULL,
    address_id integer NOT NULL,
    user_id integer NOT NULL,
    fixture character varying,
    temperature character varying,
    turbidity character varying,
    chlorine character varying,
    ph_level character varying,
    delete_type integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    task_id integer NOT NULL,
    coliform boolean DEFAULT true
);


--
-- TOC entry 2775 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN samples.coliform; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN samples.coliform IS 'o for false
1 for true';


--
-- TOC entry 202 (class 1259 OID 16432)
-- Name: status_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 225 (class 1259 OID 16718)
-- Name: status; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE status (
    id integer DEFAULT nextval('status_id_seq'::regclass) NOT NULL,
    status character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 203 (class 1259 OID 16434)
-- Name: task_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 226 (class 1259 OID 16727)
-- Name: task; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE task (
    id integer DEFAULT nextval('task_id_seq'::regclass) NOT NULL,
    user_id integer,
    assign_by integer,
    address_id integer,
    assign_date character varying,
    schedule_date character varying,
    completed_date character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    total_sample integer,
    sample_required integer,
    status integer DEFAULT 1 NOT NULL,
    coliform boolean NOT NULL,
    copper boolean NOT NULL,
    metals boolean NOT NULL,
    emergency_sample boolean NOT NULL,
    phone_no character varying,
    is_delete integer DEFAULT 0 NOT NULL,
    emergency_type integer,
    comments character varying,
    distribution_id integer
);


--
-- TOC entry 2776 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN task.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN task.user_id IS 'Assign to(Current login user Type = Sampler )';


--
-- TOC entry 2777 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN task.assign_by; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN task.assign_by IS 'Manager, Admin ids';


--
-- TOC entry 2778 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN task.address_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN task.address_id IS 'Sample Site Address Ids';


--
-- TOC entry 2779 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN task.emergency_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN task.emergency_type IS 'emergency_type id';


--
-- TOC entry 204 (class 1259 OID 16436)
-- Name: user_address_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 227 (class 1259 OID 16738)
-- Name: user_address; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_address (
    id integer DEFAULT nextval('user_address_id_seq'::regclass) NOT NULL,
    user_id integer NOT NULL,
    address_id integer
);


--
-- TOC entry 205 (class 1259 OID 16438)
-- Name: user_distribution_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_distribution_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 228 (class 1259 OID 16742)
-- Name: user_distribution_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_distribution_roles (
    id integer DEFAULT nextval('user_distribution_roles_id_seq'::regclass) NOT NULL,
    user_id integer NOT NULL,
    db_system_id integer NOT NULL,
    roles_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 206 (class 1259 OID 16440)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2780 (class 0 OID 0)
-- Dependencies: 206
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- TOC entry 2338 (class 2604 OID 17811)
-- Name: user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- TOC entry 2729 (class 0 OID 16522)
-- Dependencies: 208
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: -
--

COPY address (id, coordinate_id, street_1, street_2, city, state, zip, created_at, updated_at) FROM stdin;
96	48	D 64	Sector 63	Noida	Uttar Pradesh	201301	2018-01-08 10:37:57.330704	2018-01-08 10:37:57.330704
97	49	D 64	Sector 63	Noida	Uttar Pradesh	201301	2018-01-08 11:30:48.827049	2018-01-08 11:30:48.827049
98	50	 	 	 	 		2018-01-08 12:55:15.720677	2018-01-08 12:55:15.720677
99	51	D-64	Sector 63	Noida	Uttar Pradesh	201301	2018-01-08 12:58:35.774688	2018-01-08 12:58:35.774688
51	3	1101	Camden Ave	Salisbury	MD	21801	2017-12-18 13:48:38.315179	2017-12-18 13:48:38.315179
52	4	1413	Wesley Dr	Salisbury	MD	21801	2017-12-18 13:52:04.502182	2017-12-18 13:52:04.502182
100	52	 	 	 	 		2018-01-09 10:01:33.521415	2018-01-09 10:01:33.521415
58	10	D-64	Sector 63	Noida	Uttar Pradesh	201302	2017-12-19 13:19:59.330426	2017-12-19 13:19:59.330426
60	12	D-24	Sector 63	Noida	UP	201301	2017-12-19 13:41:56.840629	2017-12-19 13:41:56.840629
54	6	D 64	Sector 63	Noida	Uttar Pradesh	201301	2017-12-18 14:18:40.241629	2017-12-18 14:18:40.241629
61	13	A-64	Sector 63	Noida	Uttar Pradesh	201301	2017-12-19 13:43:35.699746	2017-12-19 13:43:35.699746
56	8	D-63	sec 63	Noida	Uttar Pradesh	201010	2017-12-18 15:40:25.199538	2017-12-18 15:40:25.199538
101	53	 	 	 	 		2018-01-09 10:03:44.025695	2018-01-09 10:03:44.025695
102	54	Milford 	St	Salisbury	MD	21804	2018-01-09 10:51:06.57175	2018-01-09 10:51:06.57175
50	2	D-65	Sector 62	Noida	Uttar Pradesh	201301	2017-12-18 12:38:36.979231	2017-12-18 12:38:36.979231
103	55	 	 	 	 		2018-01-09 13:47:46.004522	2018-01-09 13:47:46.004522
104	56	 	 	 	 		2018-01-09 13:49:53.247784	2018-01-09 13:49:53.247784
105	57	 	 	 	 		2018-01-09 13:50:29.438496	2018-01-09 13:50:29.438496
106	58	 	 	 	 		2018-01-09 13:52:19.412354	2018-01-09 13:52:19.412354
107	59	 	 	 	 		2018-01-09 13:56:36.869359	2018-01-09 13:56:36.869359
108	60	 	 	 	 		2018-01-09 14:04:32.543187	2018-01-09 14:04:32.543187
109	61	 	 	 	 		2018-01-09 14:05:47.458153	2018-01-09 14:05:47.458153
110	62	 	 	 	 		2018-01-09 14:14:21.521313	2018-01-09 14:14:21.521313
94	46	D 64	Sector 63	Noida	Uttar Pradesh	201301	2018-01-04 10:26:27.701817	2018-01-04 10:26:27.701817
112	64	 	 	 	 		2018-01-10 19:08:35.439151	2018-01-10 19:08:35.439151
113	65	 	 	 	 		2018-01-10 19:13:54.852472	2018-01-10 19:13:54.852472
62	14	D 64	D 64	Noida	UP	201301	2017-12-21 08:02:11.044703	2017-12-21 08:02:11.044703
59	11	D 64	Sector 63	Noida	Uttar Pradesh	201301	2017-12-19 13:29:30.684611	2017-12-19 13:29:30.684611
63	15	Noida	Noida	Noida	UP	201301	2017-12-21 12:16:21.341056	2017-12-21 12:16:21.341056
114	66	Salisbury	Blvd	Salisbury	MD	21801	2018-01-11 06:21:13.992154	2018-01-11 06:21:13.992154
115	67	Union Castle	Row	Brooklands	Milton Keynes	21801	2018-01-11 07:08:49.296361	2018-01-11 07:08:49.296361
64	16	D 64	Sector 63	Noida	Uttar Pradesh	201301	2017-12-21 12:18:59.19162	2017-12-21 12:18:59.19162
20	16	D 64	sec 63	Noida	UP	201301	2018-01-03 07:00:32.178804	2018-01-03 07:00:32.178804
55	7	D-63	sec 63	Noida	Uttar Pradesh	201010	2017-12-18 15:32:26.784527	2017-12-18 15:32:26.784527
65	17						2018-01-04 07:12:54.600616	2018-01-04 07:12:54.600616
66	18						2018-01-04 07:20:46.302602	2018-01-04 07:20:46.302602
116	68	D-64	Sector 63	Noida	UP	201302	2018-01-11 07:16:09.665144	2018-01-11 07:16:09.665144
57	9	D 64	Sector 63	Noida	UP	201301	2017-12-19 10:35:27.478117	2017-12-19 10:35:27.478117
67	19						2018-01-04 07:54:25.755798	2018-01-04 07:54:25.755798
68	20						2018-01-04 08:01:54.10219	2018-01-04 08:01:54.10219
69	21						2018-01-04 08:03:50.19494	2018-01-04 08:03:50.19494
70	22						2018-01-04 08:05:51.912541	2018-01-04 08:05:51.912541
71	23						2018-01-04 08:07:25.793957	2018-01-04 08:07:25.793957
117	69	D-63	sector 63	Noida	Uttar Pradesh	201301	2018-01-11 07:54:47.567336	2018-01-11 07:54:47.567336
87	39	 	 	 	 		2018-01-04 09:33:06.564461	2018-01-04 09:33:06.564461
88	40	 	 	 	 		2018-01-04 09:35:42.612795	2018-01-04 09:35:42.612795
89	41	 	 	 	 		2018-01-04 09:38:44.876402	2018-01-04 09:38:44.876402
90	42	 	 	 	 		2018-01-04 09:40:05.640756	2018-01-04 09:40:05.640756
91	43	 	 	 	 		2018-01-04 10:06:41.432835	2018-01-04 10:06:41.432835
92	44	 	 	 	 		2018-01-04 10:10:14.80689	2018-01-04 10:10:14.80689
93	45	 	 	 	 		2018-01-04 10:18:29.432463	2018-01-04 10:18:29.432463
86	38	D 64	Sec 63	Noida	Uttar Pradesh	201301	2018-01-04 09:31:50.1107	2018-01-04 09:31:50.1107
111	63	 D 64	Sector 63	 Noida	Uttar Pradesh	201301	2018-01-10 15:16:21.580943	2018-01-10 15:16:21.580943
95	47	D 64	Sec 63	Noida	UP	201301	2018-01-04 11:13:25.838545	2018-01-04 11:13:25.838545
53	5						2017-12-18 14:00:14.406191	2017-12-18 14:00:14.406191
118	70	D 65	D 65	Noida	UP		2018-01-12 06:29:59.153755	2018-01-12 06:29:59.153755
119	71	D 66	D66	Noida	UP	123456789	2018-01-12 07:56:27.700222	2018-01-12 07:56:27.700222
120	72	sc	svc	noida	up	222222222	2018-01-12 08:11:01.133746	2018-01-12 08:11:01.133746
121	73	d58	d58	noida	up	201301	2018-01-12 08:13:23.648726	2018-01-12 08:13:23.648726
122	74	d98	d98	noida	up	201301	2018-01-12 08:15:05.6951	2018-01-12 08:15:05.6951
\.


--
-- TOC entry 2781 (class 0 OID 0)
-- Dependencies: 185
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('address_id_seq', 122, true);


--
-- TOC entry 2730 (class 0 OID 16531)
-- Dependencies: 209
-- Data for Name: alert; Type: TABLE DATA; Schema: public; Owner: -
--

COPY alert (id, sender_id, message_type, recipient_id, message, acknowledged_at, created_at, updated_at, subject) FROM stdin;
3	4	3	6	Water OPS......	2017-12-18 14:45:24.275184	2017-12-18 14:45:24.275184	2017-12-18 14:45:24.275184	Hello
7	4	1	7	jksadhhsdjk'asdsad'sadsa	2017-12-19 11:13:35.856709	2017-12-19 11:13:35.856709	2017-12-19 11:13:35.856709	test
8	7	3	11	Test escape string " asd 'asd sad.<br/> asdasdasd.a sd<br/>sad <br/>asd<br/>sadsa	2017-12-19 11:15:56.553972	2017-12-19 11:15:56.553972	2017-12-19 11:15:56.553972	Test
6	7	3	13	This is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to usi.<br/>.	2017-12-19 10:57:10.964343	2017-12-19 10:57:10.964343	2017-12-19 10:57:10.964343	test
16	18	3	15	hi	2017-12-21 11:23:31.39707	2017-12-21 11:23:31.39707	2017-12-21 11:23:31.39707	hello
5	7	3	13	Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, "when an unknown printer took a galley of type and scrambled it to make a type specimen book"." It has survived not only five" "centuries", "but also the leap into electronic" "typesetting", "remaining essentially unchanged"." It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum" "passages", and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.<br/><br/>Hassan Ali	2017-12-19 10:51:21.056729	2017-12-19 10:51:21.056729	2017-12-19 10:51:21.056729	Shekhar test draft
4	7	3	4	Quick reply test	2017-12-19 08:12:44.937595	2017-12-19 08:12:44.937595	2017-12-19 08:12:44.937595	Hello World
9	7	2	6	asdsadsad	2017-12-19 12:50:46.286221	2017-12-19 12:50:46.286221	2017-12-19 12:50:46.286221	asd
10	18	1	11	Hi, <br/>Vikash Sir I am Vijay   i am sending message for Test.<br/><br/>thanks	2017-12-21 08:41:42.382563	2017-12-21 08:41:42.382563	2017-12-21 08:41:42.382563	Test Message
12	18	1	7	hello	2017-12-21 11:21:18.425213	2017-12-21 11:21:18.425213	2017-12-21 11:21:18.425213	Test Message
13	18	1	7	hello	2017-12-21 11:21:25.643985	2017-12-21 11:21:25.643985	2017-12-21 11:21:25.643985	Test Message
14	18	1	7	hello	2017-12-21 11:22:42.141455	2017-12-21 11:22:42.141455	2017-12-21 11:22:42.141455	Reply: "Test Message"
15	18	1	7	hgjhjghjgjgj	2017-12-21 11:23:05.297418	2017-12-21 11:23:05.297418	2017-12-21 11:23:05.297418	Reply: "Test Message"
1	4	3	7	Hello World	2017-12-18 14:35:22.61411	2017-12-18 14:35:22.61411	2017-12-18 14:35:22.61411	Hello World
11	7	3	18	Hi , This Is Test Message 	2017-12-21 08:43:19.236683	2017-12-21 08:43:19.236683	2017-12-21 08:43:19.236683	Test Message
17	18	3	7	test	2017-12-21 11:24:55.300641	2017-12-21 11:24:55.300641	2017-12-21 11:24:55.300641	test
18	18	3	11	test	2017-12-21 11:25:50.718951	2017-12-21 11:25:50.718951	2017-12-21 11:25:50.718951	test
19	18	3	13	test	2017-12-21 11:27:40.034797	2017-12-21 11:27:40.034797	2017-12-21 11:27:40.034797	test
20	18	1	19	Test	2017-12-22 07:46:59.591543	2017-12-22 07:46:59.591543	2017-12-22 07:46:59.591543	Test
21	31	1	32	test	2018-01-12 07:58:18.605969	2018-01-12 07:58:18.605969	2018-01-12 07:58:18.605969	Test
22	31	3	7	hi	2018-01-12 08:00:38.495971	2018-01-12 08:00:38.495971	2018-01-12 08:00:38.495971	hi
\.


--
-- TOC entry 2782 (class 0 OID 0)
-- Dependencies: 187
-- Name: alert_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('alert_id_seq', 22, true);


--
-- TOC entry 2731 (class 0 OID 16541)
-- Dependencies: 210
-- Data for Name: billing_address; Type: TABLE DATA; Schema: public; Owner: -
--

COPY billing_address (id, user_id, street_1, street_2, city, state, zip, card_type, card_name, card_expiry_month, card_expiry_year, card_ccv, card_no, created_at, updated_at, coordinate_id) FROM stdin;
\.


--
-- TOC entry 2783 (class 0 OID 0)
-- Dependencies: 188
-- Name: billing_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('billing_address_id_seq', 1, false);


--
-- TOC entry 2755 (class 0 OID 17083)
-- Dependencies: 234
-- Data for Name: boarding_additional_info_location; Type: TABLE DATA; Schema: public; Owner: -
--

COPY boarding_additional_info_location (id, distribution_id, pws_location_country, pws_location_town, entry_point_distribution_address, entry_point_distribution_city, entry_point_distribution_state, entry_point_distribution_zip, water_plant_address, water_plant_city, water_plant_state, water_plant_zip, updated_at, created_at) FROM stdin;
1	1	Noida 	sec 63	Noida	Sec 63	Uttar Pradesh	201010	Noida	Sec 63	uttar Pradesh	201010	2017-12-21 13:23:32.622893	2017-12-18 16:08:34.850079
3	35	India	Noida	D 64 Sector 63	Noida	UP	201301	D 64 Sector 63	Noida	UP	201301	2018-01-04 11:10:58.395626	2018-01-04 11:10:58.395626
4	43	India	Noida	D 64	Noida	UP	201301	D 64	Noida	UP	201301	2018-01-08 12:45:46.873421	2018-01-08 12:45:46.873421
5	43	India	Noida	D 64	Noida	UP	201301	D 64	Noida	UP	201301	2018-01-08 12:45:46.980634	2018-01-08 12:45:46.980634
6	44	India	Noida	D 64	Noida	Uttar Pradesh	201301	D 64	Noida	Uttar Pradesh	201301	2018-01-08 13:04:12.726584	2018-01-08 13:04:12.726584
7	47	Wayne St Salisbury	MD	Salisbury Blvd	Salisbury	MD	21801					2018-01-09 10:54:41.617342	2018-01-09 10:54:41.617342
\.


--
-- TOC entry 2784 (class 0 OID 0)
-- Dependencies: 233
-- Name: boarding_additional_info_location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('boarding_additional_info_location_id_seq', 7, true);


--
-- TOC entry 2732 (class 0 OID 16550)
-- Dependencies: 211
-- Data for Name: containers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY containers (id, assigned_to, assigned_by, date_issued, time_issued, disposer_id, disposal_reason, created_at, updated_at, time_used, "QR_code", "bar_Code", "scan_via_QR", scan_via_bar, status, incubation_start, incubation_end, comments, distribution_id, reasons_for_failure) FROM stdin;
3	7	4	2017-12-26 00:00:00	\N	\N	\N	2017-12-20 08:35:40.855386	2017-12-20 08:35:40.855386	2017-12-20 08:35:40.855386	\N	\N	\N	\N	5	2017-12-20 08:35:40.855386	2017-12-25 08:35:40.855386	\N	1	\N
5	1	4	2017-12-22 00:00:00	\N	\N	\N	2017-12-21 08:27:34.816176	2017-12-21 08:27:34.816176	2017-12-21 08:27:34.816176	\N	\N	f	f	6	2018-01-05 08:35:40.855386	2018-01-10 08:35:40.855386	Well Done	1	\N
4	7	4	2017-12-20 00:00:00	\N	\N	\N	2017-12-21 08:26:16.76977	2017-12-21 08:26:16.76977	2017-12-21 08:26:16.76977	\N	\N	f	f	11	2017-12-25 08:35:40.855386	2017-12-30 08:35:40.855386	Container tampered/contaminated	1	\N
8	\N	\N	\N	\N	\N	\N	2017-12-22 11:31:03.685111	2017-12-22 11:31:03.685111	2017-12-22 11:31:03.685111	1234	123456987	t	t	9	2018-01-20 08:35:40.855386	2018-01-25 08:35:40.855386	Good Job	1	\N
9	\N	\N	\N	\N	\N	\N	2017-12-22 11:33:53.184307	2017-12-22 11:33:53.184307	2017-12-22 11:33:53.184307	1234	123456789	t	t	9	2018-01-25 08:35:40.855386	2018-01-30 08:35:40.855386	\N	1	\N
7	\N	\N	2017-12-20 00:00:00	\N	\N	\N	2017-12-22 11:28:10.959795	2017-12-22 11:28:10.959795	2017-12-22 11:28:10.959795	123456	0705632085943	t	t	9	2018-01-15 08:35:40.855386	2018-01-20 08:35:40.855386	Well done	1	\N
6	7	4	2017-12-21 00:00:00	\N	\N	\N	2017-12-21 08:28:56.301331	2017-12-21 08:28:56.301331	2017-12-21 08:28:56.301331	123456789	0705632085943	f	f	9	2018-01-10 08:35:40.855386	2018-01-15 08:35:40.855386	Container expired	1	Test Reason
\.


--
-- TOC entry 2785 (class 0 OID 0)
-- Dependencies: 189
-- Name: containers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('containers_id_seq', 11, true);


--
-- TOC entry 2733 (class 0 OID 16561)
-- Dependencies: 212
-- Data for Name: contaminants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY contaminants (id, contaminant, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 2786 (class 0 OID 0)
-- Dependencies: 186
-- Name: contaminants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('contaminants_id_seq', 1, false);


--
-- TOC entry 2734 (class 0 OID 16570)
-- Dependencies: 213
-- Data for Name: coordinate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY coordinate (id, latitude, longitude, created_at, updated_at) FROM stdin;
1	38.3427220	-75.6057480	2017-12-15 08:28:27.664748	2017-12-15 08:28:27.664748
3	38.3442366	-75.6054921	2017-12-18 13:48:38.315179	2017-12-18 13:48:38.315179
4	38.3398714	-75.6076884	2017-12-18 13:52:04.502182	2017-12-18 13:52:04.502182
6	28.5821195	77.3266991	2017-12-18 14:18:40.241629	2017-12-18 14:18:40.241629
8	28.6246739	77.3818127	2017-12-18 15:40:25.197562	2017-12-18 15:40:25.197562
7	28.6249200	77.3832930	2017-12-18 15:32:26.782529	2017-12-18 15:32:26.782529
2	38.3606736	-75.5993692	2017-12-15 10:18:31.818837	2017-12-15 10:18:31.818837
9	28.5821195	77.3266991	2017-12-19 10:35:27.478117	2017-12-19 10:35:27.478117
10	28.6306634	77.3820725	2017-12-19 13:19:59.328488	2017-12-19 13:19:59.328488
12	28.6310024	77.3820233	2017-12-19 13:41:56.838592	2017-12-19 13:41:56.838592
13	28.6306634	77.3820725	2017-12-19 13:43:35.69779	2017-12-19 13:43:35.69779
14	28.6306634	77.3820725	2017-12-21 08:02:11.029116	2017-12-21 08:02:11.029116
11	28.5821195	77.3266991	2017-12-19 13:29:30.682656	2017-12-19 13:29:30.682656
15	28.5624120	77.3170076	2017-12-21 12:16:21.341056	2017-12-21 12:16:21.341056
16	28.5821195	77.3266991	2017-12-21 12:18:59.19162	2017-12-21 12:18:59.19162
17	0.0000000	0.0000000	2018-01-04 07:12:54.594597	2018-01-04 07:12:54.594597
18	0.0000000	0.0000000	2018-01-04 07:20:46.298604	2018-01-04 07:20:46.298604
19	0.0000000	0.0000000	2018-01-04 07:54:25.749798	2018-01-04 07:54:25.749798
20	0.0000000	0.0000000	2018-01-04 08:01:54.100226	2018-01-04 08:01:54.100226
21	0.0000000	0.0000000	2018-01-04 08:03:50.192938	2018-01-04 08:03:50.192938
22	0.0000000	0.0000000	2018-01-04 08:05:51.910635	2018-01-04 08:05:51.910635
23	0.0000000	0.0000000	2018-01-04 08:07:25.791994	2018-01-04 08:07:25.791994
24	0.0000000	0.0000000	2018-01-04 08:09:36.851739	2018-01-04 08:09:36.851739
25	0.0000000	0.0000000	2018-01-04 08:12:06.464709	2018-01-04 08:12:06.464709
26	0.0000000	0.0000000	2018-01-04 08:21:33.540258	2018-01-04 08:21:33.540258
27	0.0000000	0.0000000	2018-01-04 08:31:43.854777	2018-01-04 08:31:43.854777
28	0.0000000	0.0000000	2018-01-04 08:53:22.797324	2018-01-04 08:53:22.797324
29	0.0000000	0.0000000	2018-01-04 08:54:07.591917	2018-01-04 08:54:07.591917
30	0.0000000	0.0000000	2018-01-04 08:55:03.948228	2018-01-04 08:55:03.948228
31	0.0000000	0.0000000	2018-01-04 08:55:58.948575	2018-01-04 08:55:58.948575
32	0.0000000	0.0000000	2018-01-04 09:07:55.421586	2018-01-04 09:07:55.421586
37	0.0000000	0.0000000	2018-01-04 09:28:16.273535	2018-01-04 09:28:16.273535
38	0.0000000	0.0000000	2018-01-04 09:31:50.1107	2018-01-04 09:31:50.1107
39	0.0000000	0.0000000	2018-01-04 09:33:06.564461	2018-01-04 09:33:06.564461
40	0.0000000	0.0000000	2018-01-04 09:35:42.610796	2018-01-04 09:35:42.610796
41	0.0000000	0.0000000	2018-01-04 09:38:44.875362	2018-01-04 09:38:44.875362
42	0.0000000	0.0000000	2018-01-04 09:40:05.640756	2018-01-04 09:40:05.640756
43	0.0000000	0.0000000	2018-01-04 10:06:41.430841	2018-01-04 10:06:41.430841
44	0.0000000	0.0000000	2018-01-04 10:10:14.80689	2018-01-04 10:10:14.80689
45	0.0000000	0.0000000	2018-01-04 10:18:29.430452	2018-01-04 10:18:29.430452
46	0.0000000	0.0000000	2018-01-04 10:26:27.70087	2018-01-04 10:26:27.70087
47	28.6306634	77.3820725	2018-01-04 11:13:25.836557	2018-01-04 11:13:25.836557
48	28.6306634	77.3820725	2018-01-08 10:37:57.330704	2018-01-08 10:37:57.330704
49	0.0000000	0.0000000	2018-01-08 11:30:48.811431	2018-01-08 11:30:48.811431
50	0.0000000	0.0000000	2018-01-08 12:55:15.720677	2018-01-08 12:55:15.720677
51	28.6306634	77.3820725	2018-01-08 12:58:35.774688	2018-01-08 12:58:35.774688
52	0.0000000	0.0000000	2018-01-09 10:01:33.51947	2018-01-09 10:01:33.51947
53	0.0000000	0.0000000	2018-01-09 10:03:44.025695	2018-01-09 10:03:44.025695
54	38.4170018	-75.5624006	2018-01-09 10:51:06.57175	2018-01-09 10:51:06.57175
55	0.0000000	0.0000000	2018-01-09 13:47:46.004522	2018-01-09 13:47:46.004522
56	0.0000000	0.0000000	2018-01-09 13:49:53.247784	2018-01-09 13:49:53.247784
57	0.0000000	0.0000000	2018-01-09 13:50:29.436464	2018-01-09 13:50:29.436464
58	0.0000000	0.0000000	2018-01-09 13:52:19.410316	2018-01-09 13:52:19.410316
59	0.0000000	0.0000000	2018-01-09 13:56:36.853729	2018-01-09 13:56:36.853729
60	0.0000000	0.0000000	2018-01-09 14:04:32.541237	2018-01-09 14:04:32.541237
61	0.0000000	0.0000000	2018-01-09 14:05:47.457118	2018-01-09 14:05:47.457118
62	0.0000000	0.0000000	2018-01-09 14:14:21.521313	2018-01-09 14:14:21.521313
63	0.0000000	0.0000000	2018-01-10 15:16:21.580943	2018-01-10 15:16:21.580943
64	0.0000000	0.0000000	2018-01-10 19:08:35.439151	2018-01-10 19:08:35.439151
65	0.0000000	0.0000000	2018-01-10 19:13:54.852472	2018-01-10 19:13:54.852472
66	38.3928226	-75.5746475	2018-01-11 06:21:13.992154	2018-01-11 06:21:13.992154
67	52.0486171	-0.6833597	2018-01-11 07:08:49.280772	2018-01-11 07:08:49.280772
68	28.6306634	77.3820725	2018-01-11 07:16:09.665144	2018-01-11 07:16:09.665144
69	28.5821195	77.3266991	2018-01-11 07:54:47.567336	2018-01-11 07:54:47.567336
5	28.6128619	77.3766902	2017-12-18 14:00:14.406191	2017-12-18 14:00:14.406191
70	51.5244728	-0.0879232	2018-01-12 06:29:59.153755	2018-01-12 06:29:59.153755
71	28.5944306	77.3598573	2018-01-12 07:56:27.700222	2018-01-12 07:56:27.700222
72	28.5841025	77.3144254	2018-01-12 08:11:01.133746	2018-01-12 08:11:01.133746
73	28.6284537	77.3769437	2018-01-12 08:13:23.648726	2018-01-12 08:13:23.648726
74	28.5821195	77.3266991	2018-01-12 08:15:05.6951	2018-01-12 08:15:05.6951
\.


--
-- TOC entry 2787 (class 0 OID 0)
-- Dependencies: 190
-- Name: coordinate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('coordinate_id_seq', 74, true);


--
-- TOC entry 2759 (class 0 OID 17204)
-- Dependencies: 238
-- Data for Name: distribution_additional_monitering; Type: TABLE DATA; Schema: public; Owner: -
--

COPY distribution_additional_monitering (id, sampling_frequency, complaince_requirements, sampling_comments, notes, contaminants, distribution_id, created_at, updated_at) FROM stdin;
1	Monthly	Complaince Requirements:	Sampling Comments:	General Notes:	[{"contaminant":"Nitrate"}, "{""contaminant"":""Lead""}", {"contaminant":"Nitrate"}]	1	2017-12-21 15:03:50.500148	2017-12-21 15:03:50.500148
2	Monthly	zxcZC	zCxzc	General Note	[{"contaminant":"Nitrate"}, "{""contaminant"":""Lead""}", {"contaminant":"Nitrate"}]	1	2017-12-21 15:06:27.437925	2017-12-21 15:06:27.437925
3	Monthly	Complaince Requirements:	Sampling Comments:	General Notes:	[{"contaminant":"Nitrate"}, "{""contaminant"":""Lead""}", {"contaminant":"Lead"}]	1	2018-01-03 08:03:14.204585	2018-01-03 08:03:14.204585
4	Weekly	Testing for Water OPS system	Sample required	Hello World	[{"contaminant":"Chlorine"}, "{""contaminant"":""Nitrate""}", {"contaminant":"Nitrate"}]	35	2018-01-04 12:47:38.303911	2018-01-04 12:47:38.303911
5	Weekly	Lorem ipsum dolor sit amet, "consectetur adipiscing elit"." Aenean orci" "libero", "consectetur in iaculis" "eu", iaculis ac enim. Maecenas ultricies finibus ex et vehicula.	Lorem ipsum dolor sit amet, "consectetur adipiscing elit"." Aenean orci" "libero", "consectetur in iaculis" "eu", iaculis ac enim. Maecenas ultricies finibus ex et vehicula.	Lorem ipsum dolor sit amet, "consectetur adipiscing elit"." Aenean orci" "libero", "consectetur in iaculis" "eu", iaculis ac enim. Maecenas ultricies finibus ex et vehicula.	[{"contaminant":"Chlorine"}, "{""contaminant"":""Nitrate""}", {"contaminant":"Lead"}]	35	2018-01-04 12:54:36.174816	2018-01-04 12:54:36.174816
6	Weekly	Compliance Requirements notes	Sampling Comments	General notes	[{"contaminant":"Chlorine"}, "{""contaminant"":""Nitrate""}", {"contaminant":"Nitrate"}]	44	2018-01-08 14:12:37.719905	2018-01-08 14:12:37.719905
7	Weekly	Compliance Requirements notes	Sampling Comments	General notes	[{"contaminant":"Chlorine"}, "{""contaminant"":""Nitrate""}", {"contaminant":"Nitrate"}]	44	2018-01-08 14:12:37.751155	2018-01-08 14:12:37.751155
\.


--
-- TOC entry 2788 (class 0 OID 0)
-- Dependencies: 237
-- Name: distribution_additional_monitering_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('distribution_additional_monitering_id_seq', 7, true);


--
-- TOC entry 2751 (class 0 OID 16938)
-- Dependencies: 230
-- Data for Name: distribution_billing_address; Type: TABLE DATA; Schema: public; Owner: -
--

COPY distribution_billing_address (id, distribution_id, street_1, street_2, city, state, zip, card_type, card_name, card_expiry_month, card_expiry_year, card_ccv, card_no, created_at, updated_at, coordinate_id, billing_cycle, public_water_system) FROM stdin;
1	1	D 64	Sec 63	Noida	Uttar Pradesh	201301	Discover	Matthew Beard	9	2034	180	1234123412341234	2017-12-18 12:41:01.244199	2017-12-18 12:41:01.244199	\N	\N	\N
2	35	1307	1307	Salisbury	MD	21801	Visa	Hassan Ali	11	2023	123	4111222244446667	2018-01-04 13:21:46.925802	2018-01-04 13:21:46.925802	\N	\N	\N
3	44	D 64	Sector 63	Noida	Uttar Pradesh	201301	Master Card	Nishant garg	3	2020	122	4166234512349876	2018-01-08 14:14:03.516579	2018-01-08 14:14:03.516579	\N	\N	\N
4	47	D-64	Setor 63	Noida	Uttar Pradesh	201301	Visa	SBI	8	2032	122		2018-01-09 12:15:44.716939	2018-01-09 12:15:44.716939	\N	\N	\N
5	2	D-64 Sector 63 Noida	noida sec 63	Noida	Uttar Pradesh	201301	Visa	SBI	9	2030	122		2018-01-09 14:31:37.130117	2018-01-09 14:31:37.130117	\N	\N	\N
6	56	D 64	D 64	Noida	UP	201301	Visa	Hassan Ali	1	2022	123	4122660032310011	2018-01-12 07:05:26.010824	2018-01-12 07:05:26.010824	\N	\N	\N
7	56	49	Featherstone Street	London	London	EC1Y 8SY	Visa	Hassan Ali	1	2022	123	4122660032310011	2018-01-12 07:46:14.500035	2018-01-12 07:46:14.500035	\N	\N	\N
\.


--
-- TOC entry 2789 (class 0 OID 0)
-- Dependencies: 229
-- Name: distribution_billing_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('distribution_billing_address_id_seq', 7, true);


--
-- TOC entry 2735 (class 0 OID 16588)
-- Dependencies: 214
-- Data for Name: distribution_id_details; Type: TABLE DATA; Schema: public; Owner: -
--

COPY distribution_id_details (id, distribution_id, address_id, user_id, created_at, updated_at) FROM stdin;
8	1	50	4	2017-12-18 12:39:22.744652	2017-12-18 12:39:22.744652
10	1	70	4	2018-01-04 08:05:51.914598	2018-01-04 08:05:51.914598
24	35	86	7	2018-01-04 09:31:50.1107	2018-01-04 09:31:50.1107
25	36	87	7	2018-01-04 09:33:06.58007	2018-01-04 09:33:06.58007
27	38	89	4	2018-01-04 09:38:44.878398	2018-01-04 09:38:44.878398
28	39	90	7	2018-01-04 09:40:05.640756	2018-01-04 09:40:05.640756
29	40	91	7	2018-01-04 10:06:41.434842	2018-01-04 10:06:41.434842
30	41	92	7	2018-01-04 10:10:14.80689	2018-01-04 10:10:14.80689
31	42	93	4	2018-01-04 10:18:29.433444	2018-01-04 10:18:29.433444
32	43	94	7	2018-01-04 10:26:27.704815	2018-01-04 10:26:27.704815
33	44	97	7	2018-01-08 11:30:48.827049	2018-01-08 11:30:48.827049
34	45	98	7	2018-01-08 12:55:15.720677	2018-01-08 12:55:15.720677
35	46	100	4	2018-01-09 10:01:33.537434	2018-01-09 10:01:33.537434
36	47	101	4	2018-01-09 10:03:44.025695	2018-01-09 10:03:44.025695
37	48	103	4	2018-01-09 13:47:46.004522	2018-01-09 13:47:46.004522
38	49	104	4	2018-01-09 13:49:53.247784	2018-01-09 13:49:53.247784
39	50	105	7	2018-01-09 13:50:29.440507	2018-01-09 13:50:29.440507
40	51	106	7	2018-01-09 13:52:19.414316	2018-01-09 13:52:19.414316
41	52	107	7	2018-01-09 13:56:36.869359	2018-01-09 13:56:36.869359
42	53	108	7	2018-01-09 14:04:32.54524	2018-01-09 14:04:32.54524
43	54	109	4	2018-01-09 14:05:47.460118	2018-01-09 14:05:47.460118
44	55	110	4	2018-01-09 14:14:21.521313	2018-01-09 14:14:21.521313
26	2	102	4	2018-01-04 09:35:42.614826	2018-01-04 09:35:42.614826
45	56	111	7	2018-01-10 15:16:21.612192	2018-01-10 15:16:21.612192
46	57	112	4	2018-01-10 19:08:35.439151	2018-01-10 19:08:35.439151
47	58	113	4	2018-01-10 19:13:54.852472	2018-01-10 19:13:54.852472
\.


--
-- TOC entry 2790 (class 0 OID 0)
-- Dependencies: 191
-- Name: distribution_id_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('distribution_id_details_id_seq', 47, true);


--
-- TOC entry 2736 (class 0 OID 16594)
-- Dependencies: 215
-- Data for Name: distribution_system; Type: TABLE DATA; Schema: public; Owner: -
--

COPY distribution_system (id, name, population, is_suspended, is_active, created_at, updated_at, incubation_length_hours, incubation_reading_length_hours, primacy_gency, "EPA_region", primacy_type, pws_activity, pws_type, "GW_SW", owner_type, pop_cat_desc, primacy_source, "PWS_id") FROM stdin;
2	MONTROSE IMPROVEMENT DISTRICT	9900	f	t	2017-12-15 12:18:22.764014	2017-12-15 12:18:22.764014	\N	\N	NY	02	State	Active	CWS	SW	local	30 to 3000	SW	NY5903435
44	LWS26	1000	f	t	2018-01-08 11:30:48.811431	2018-01-08 11:30:48.811431	\N	\N	LWS	LW	LWS	LWS	LWS	LWS	LWS	10 - 1000	LWS	HASSLWS26
45	\N	0	f	t	2018-01-08 12:55:15.720677	2018-01-08 12:55:15.720677	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	LWS_SOFT
46	\N	0	f	t	2018-01-09 10:01:33.512413	2018-01-09 10:01:33.512413	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	NY5903434
47	Denton	900	f	t	2018-01-09 10:03:44.01012	2018-01-09 10:03:44.01012	\N	\N	NY	03	State	Active	CWS	SW	Local Government	25 to 1000	SW	NY5903433
1	Salisbury	967	f	t	2017-12-15 08:12:37.760523	2017-12-15 08:12:37.760523	24	24	NY	02	State	M	CWS	SW	Local Government	25 to 1000	Salisbury	NY5903436
48	\N	0	f	t	2018-01-09 13:47:46.004522	2018-01-09 13:47:46.004522	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	NY59034555
49	\N	0	f	t	2018-01-09 13:49:53.247784	2018-01-09 13:49:53.247784	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	NY59034444
50	\N	0	f	t	2018-01-09 13:50:29.428497	2018-01-09 13:50:29.428497	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	NY59034362
51	\N	0	f	t	2018-01-09 13:52:19.3884	2018-01-09 13:52:19.3884	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	NY590343623
52	\N	0	f	t	2018-01-09 13:56:36.853729	2018-01-09 13:56:36.853729	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	NY5903436223
39	HAs	720	f	t	2018-01-04 09:40:05.625066	2018-01-04 09:40:05.625066	\N	\N	02	EA	QA	Active	SWEs	GW	Govenment	10  to 300	HAs	HASS123
53	\N	0	f	t	2018-01-09 14:04:32.523099	2018-01-09 14:04:32.523099	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	12345
54	\N	0	f	t	2018-01-09 14:05:47.44612	2018-01-09 14:05:47.44612	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TEST1
55	\N	0	f	t	2018-01-09 14:14:21.505705	2018-01-09 14:14:21.505705	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	NY59034361
43	HASSANALI2626	1000	f	t	2018-01-04 10:26:27.691814	2018-01-04 10:26:27.691814	\N	\N	Active	EA	AA	HA	HA	HA	HA	Hassan Water System	HASSANALI2626	HA123456
7	\N	0	f	t	2018-01-03 14:50:50.38961	2018-01-03 14:50:50.38961	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	BB11
8	\N	0	f	t	2018-01-03 15:05:02.154649	2018-01-03 15:05:02.154649	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	BB22
9	\N	0	f	t	2018-01-03 15:07:36.606071	2018-01-03 15:07:36.606071	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	BB33
10	\N	0	f	t	2018-01-03 15:10:47.637422	2018-01-03 15:10:47.637422	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	456789
11	\N	0	f	t	2018-01-03 15:16:04.35734	2018-01-03 15:16:04.35734	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	343243432432
12	\N	0	f	t	2018-01-03 15:23:41.129547	2018-01-03 15:23:41.129547	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	BB44
13	\N	0	f	t	2018-01-03 15:24:51.838178	2018-01-03 15:24:51.838178	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	BB66
14	\N	0	f	t	2018-01-03 15:27:48.630248	2018-01-03 15:27:48.630248	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	333333333
15	\N	0	f	t	2018-01-03 15:28:59.793818	2018-01-03 15:28:59.793818	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	123QQQQQQ
16	\N	0	f	t	2018-01-04 07:12:54.585595	2018-01-04 07:12:54.585595	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	VK10
17	\N	0	f	t	2018-01-04 07:20:46.296602	2018-01-04 07:20:46.296602	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	
18	\N	0	f	t	2018-01-04 07:24:57.176477	2018-01-04 07:24:57.176477	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	VK11
19	\N	0	f	t	2018-01-04 07:54:25.748799	2018-01-04 07:54:25.748799	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	V100
20	\N	0	f	t	2018-01-04 08:01:54.092214	2018-01-04 08:01:54.092214	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	300
21	\N	0	f	t	2018-01-04 08:03:50.18494	2018-01-04 08:03:50.18494	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	200
22	\N	0	f	t	2018-01-04 08:05:51.903551	2018-01-04 08:05:51.903551	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	VK200
23	\N	0	f	t	2018-01-04 08:07:25.783969	2018-01-04 08:07:25.783969	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	VK500
24	\N	0	f	t	2018-01-04 08:09:36.843728	2018-01-04 08:09:36.843728	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	555500
25	\N	0	f	t	2018-01-04 08:12:06.456683	2018-01-04 08:12:06.456683	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Hassa123
26	HASSANALI	1000	f	t	2018-01-04 08:21:33.524572	2018-01-04 08:21:33.524572	\N	\N	HA	EA	\N	QWERTY	HA	GW	HA	HA Water System	HA	HASS2626
27	\N	0	f	t	2018-01-04 08:31:43.839218	2018-01-04 08:31:43.839218	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	V321
28	HASSAN	200	f	t	2018-01-04 08:55:58.940538	2018-01-04 08:55:58.940538	\N	\N	02	state	\N	NY	SWE	Active	Goverment	10 to 200	NA	100YY
29	\N	0	f	t	2018-01-04 09:07:55.412544	2018-01-04 09:07:55.412544	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TT1001
30	\N	0	f	t	2018-01-04 09:08:46.885967	2018-01-04 09:08:46.885967	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TT1002
31	\N	0	f	t	2018-01-04 09:09:58.811459	2018-01-04 09:09:58.811459	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TEST300
32	\N	0	f	t	2018-01-04 09:11:16.899815	2018-01-04 09:11:16.899815	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TEST400
33	HH	200	f	t	2018-01-04 09:16:47.386096	2018-01-04 09:16:47.386096	\N	\N	H1	02	\N	SW	SWE	GW	Goverment	20 to 200	TEST	TEST500
34	\N	0	f	t	2018-01-04 09:28:16.273535	2018-01-04 09:28:16.273535	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TEST11
36	\N	0	f	t	2018-01-04 09:33:06.564461	2018-01-04 09:33:06.564461	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	VK100
37	\N	0	f	t	2018-01-04 09:35:42.601831	2018-01-04 09:35:42.601831	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	XYZ
38	\N	0	f	t	2018-01-04 09:38:44.86636	2018-01-04 09:38:44.86636	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	XYZ12
57	\N	0	f	t	2018-01-10 19:08:35.423526	2018-01-10 19:08:35.423526	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Matt Test system1
40	\N	0	f	t	2018-01-04 10:06:41.422848	2018-01-04 10:06:41.422848	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	ASH123
41	\N	0	f	t	2018-01-04 10:10:14.80689	2018-01-04 10:10:14.80689	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TT1234
42	\N	0	f	t	2018-01-04 10:18:29.421436	2018-01-04 10:18:29.421436	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	DEMO1
58	\N	0	f	t	2018-01-10 19:13:54.836844	2018-01-10 19:13:54.836844	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1234567a
56	Qwerty	1000	f	t	2018-01-10 15:16:21.565317	2018-01-10 15:16:21.565317	\N	\N	QW	QW	A	Active	QW	GW	QW	10-1000	QW	Qwerty
35	LWS_SOFT	1000	f	t	2018-01-04 09:31:50.1107	2018-01-04 09:31:50.1107	\N	\N	LWS	03	Active	10	LWS	GWS	LWS	10 to 1000	LWS	HA22
\.


--
-- TOC entry 2791 (class 0 OID 0)
-- Dependencies: 192
-- Name: distribution_system_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('distribution_system_id_seq', 58, true);


--
-- TOC entry 2760 (class 0 OID 17368)
-- Dependencies: 239
-- Data for Name: emergency_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY emergency_type (id, emergency_type, created_at, updated_at) FROM stdin;
1	Type1	2017-12-27 09:46:56.278303	2017-12-27 09:46:56.278303
2	Type2	2017-12-27 09:47:05.168889	2017-12-27 09:47:05.168889
\.


--
-- TOC entry 2792 (class 0 OID 0)
-- Dependencies: 240
-- Name: emergency_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('emergency_type_id_seq', 2, true);


--
-- TOC entry 2757 (class 0 OID 17118)
-- Dependencies: 236
-- Data for Name: employees_recieve_report; Type: TABLE DATA; Schema: public; Owner: -
--

COPY employees_recieve_report (id, report_schedule_id, user_id, distribution_id, job_title, name, phone_number, email, crested_at, updated_at) FROM stdin;
1	8	11	1	test	Vijay Kumar		vijay.kumar@loginworks.com	2017-12-19 08:01:49.723278	2017-12-19 08:01:49.723278
4	18	4	37	test	Matthew Beard	1234567890000001	matthew.beard@o-p-s.net	2018-01-04 11:49:44.940158	2018-01-04 11:49:44.940158
5	19	21	35	Tester	Shashank Trivedi	1234567890	shashank@loginworks.com	2018-01-04 11:59:07.925112	2018-01-04 11:59:07.925112
7	21	23	44	Manager	Nishant Verma	1234567891	nishant.garg1@loginworks.com	2018-01-08 13:13:54.058044	2018-01-08 13:13:54.058044
6	20	23	44	Manager	Nishant Verma	1234567891	nishant.garg1@loginworks.com	2018-01-08 13:13:54.058044	2018-01-08 13:13:54.058044
8	22	23	44	Manager	Nishant Verma	1234567891	nishant.garg1@loginworks.com	2018-01-08 13:16:16.394805	2018-01-08 13:16:16.394805
\.


--
-- TOC entry 2793 (class 0 OID 0)
-- Dependencies: 235
-- Name: employees_recieve_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('employees_recieve_report_id_seq', 8, true);


--
-- TOC entry 2737 (class 0 OID 16606)
-- Dependencies: 216
-- Data for Name: lience; Type: TABLE DATA; Schema: public; Owner: -
--

COPY lience (id, type, created_at, updated_at) FROM stdin;
1	Water	2017-12-15 10:14:47.037029	2017-12-15 10:14:47.037029
2	Water 2	2017-12-18 12:17:24.180579	2017-12-18 12:17:24.180579
\.


--
-- TOC entry 2794 (class 0 OID 0)
-- Dependencies: 193
-- Name: lience_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('lience_id_seq', 2, true);


--
-- TOC entry 2738 (class 0 OID 16615)
-- Dependencies: 217
-- Data for Name: plant_address; Type: TABLE DATA; Schema: public; Owner: -
--

COPY plant_address (id, user_id, street_1, street_2, city, state, zip, created_at, updated_at) FROM stdin;
2	4	D-64	Sec 63	noida	UP	201301	2017-12-18 12:52:13.444312	2017-12-18 12:52:13.444312
3	5	1101	Camden Ave	Salisbury	MD	21801	2017-12-18 13:48:38.315179	2017-12-18 13:48:38.315179
4	6	1413	Wesley Dr	Salisbury	MD	21801	2017-12-18 13:52:04.517765	2017-12-18 13:52:04.517765
5	7	D 64	Sector 63	Noida	UP	201301	2017-12-18 14:00:14.421767	2017-12-18 14:00:14.421767
6	8	D 64	Sector 63	Noida	Uttar Pradesh	201301	2017-12-18 14:18:40.241629	2017-12-18 14:18:40.241629
7	13	D 64	Sector 63	Noida	UP	201301	2017-12-19 10:35:27.478117	2017-12-19 10:35:27.478117
8	14	D-64	Sector 63	Noida	Uttar Pradesh	201302	2017-12-19 13:19:59.349483	2017-12-19 13:19:59.349483
10	16	D-24	Sector 63	Noida	UP	201301	2017-12-19 13:41:56.844639	2017-12-19 13:41:56.844639
11	17	A-64	Sector 63	Noida	Uttar Pradesh	201301	2017-12-19 13:43:35.704785	2017-12-19 13:43:35.704785
12	18	D 64	Sec 63	Noida	Uttar Pradesh	201301	2017-12-21 08:02:11.107199	2017-12-21 08:02:11.107199
9	15	D 64	Sector 63	Noida	Uttar Pradesh	201301	2017-12-19 13:29:30.68869	2017-12-19 13:29:30.68869
13	19	Noida	Noida	Noida	UP	201301	2017-12-21 12:16:21.341056	2017-12-21 12:16:21.341056
14	20	D 64	Sector 63	Noida	Uttar Pradesh	201301	2017-12-21 12:18:59.19162	2017-12-21 12:18:59.19162
15	21	D 64	Sec 63	Noida	UP	201301	2018-01-04 11:13:25.842544	2018-01-04 11:13:25.842544
16	22	D 64	Sector 63	Noida	Uttar Pradesh	201301	2018-01-08 10:37:57.346323	2018-01-08 10:37:57.346323
17	23	D-64	Sector 63	Noida	Uttar Pradesh	201301	2018-01-08 12:58:35.774688	2018-01-08 12:58:35.774688
18	25	Milford 	St	Salisbury	MD	21804	2018-01-09 10:51:06.587375	2018-01-09 10:51:06.587375
19	27	Salisbury	Blvd	Salisbury	MD	21801	2018-01-11 06:21:14.007781	2018-01-11 06:21:14.007781
20	28	Union Castle	Row	Brooklands	Milton Keynes	21801	2018-01-11 07:08:49.296361	2018-01-11 07:08:49.296361
21	29	D-64	Sector 63	Noida	UP	201302	2018-01-11 07:16:09.680773	2018-01-11 07:16:09.680773
22	30	D-63	sector 63	Noida	Uttar Pradesh	201301	2018-01-11 07:54:47.582958	2018-01-11 07:54:47.582958
23	31	49	Featherstone Street	London	London	EC1Y 8SY	2018-01-12 06:29:59.169387	2018-01-12 06:29:59.169387
24	32	D 66	D66	Noida	UP	123456789	2018-01-12 07:56:27.731529	2018-01-12 07:56:27.731529
25	33	sc	svc	noida	up	222222222	2018-01-12 08:11:01.149342	2018-01-12 08:11:01.149342
26	34	d58	d58	noida	up	201301	2018-01-12 08:13:23.664322	2018-01-12 08:13:23.664322
27	35	d98	d98	noida	up	201301	2018-01-12 08:15:05.710773	2018-01-12 08:15:05.710773
\.


--
-- TOC entry 2795 (class 0 OID 0)
-- Dependencies: 194
-- Name: plant_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('plant_address_id_seq', 27, true);


--
-- TOC entry 2739 (class 0 OID 16624)
-- Dependencies: 218
-- Data for Name: report_schedule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY report_schedule (id, schedule, sanitary_surveys_date_1, sanitary_surveys_date_2, sanitary_surveys_date_3, schedule_daily, schedule_weekly, schedule_monthly, created_at, updated_at, distribution_id, user_id) FROM stdin;
13	\N	\N	\N	\N	1	1	1	2017-12-28 07:19:55.330886	2017-12-28 07:19:55.330886	1	10
14	\N	\N	\N	\N	1	1	1	2017-12-28 07:20:03.940223	2017-12-28 07:20:03.940223	1	15
8	weekly	2017-10-10	\N	\N	1	1	1	2017-12-28 07:19:43.205505	2017-12-28 07:19:43.205505	1	7
18	["Daily", "Weekly", "Monthly"]	2018-01-08	2018-01-22	2018-01-14	1	1	1	2018-01-04 11:49:44.940158	2018-01-04 11:49:44.940158	37	\N
19	["Daily", "Weekly", "Monthly"]	2018-01-10	2018-01-17	2018-01-24	1	1	1	2018-01-04 11:59:07.925112	2018-01-04 11:59:07.925112	35	\N
20	["Daily", "Weekly", "Monthly"]	2018-01-09	2018-01-16	2018-01-23	1	1	1	2018-01-08 13:13:54.042419	2018-01-08 13:13:54.042419	44	\N
21	["Daily", "Weekly", "Monthly"]	2018-01-09	2018-01-16	2018-01-23	1	1	1	2018-01-08 13:13:54.042419	2018-01-08 13:13:54.042419	44	\N
22	["Daily", "Weekly", "Monthly"]	2018-01-24	2018-01-30	2018-01-31	1	1	1	2018-01-08 13:16:16.389656	2018-01-08 13:16:16.389656	44	\N
\.


--
-- TOC entry 2796 (class 0 OID 0)
-- Dependencies: 195
-- Name: report_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('report_schedule_id_seq', 22, true);


--
-- TOC entry 2762 (class 0 OID 17409)
-- Dependencies: 241
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: -
--

COPY reports (id, download, send_to_email, email, user_id, daily, weekly, monthly, from_date, to_date, created_by, created_at, updated_at) FROM stdin;
18	t	t		7	t	f	t	2017-12-01	2017-12-03	4	2017-12-28 08:39:04.504662	2017-12-28 08:39:04.504662
\.


--
-- TOC entry 2797 (class 0 OID 0)
-- Dependencies: 242
-- Name: reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('reports_id_seq', 18, true);


--
-- TOC entry 2740 (class 0 OID 16636)
-- Dependencies: 219
-- Data for Name: request_container; Type: TABLE DATA; Schema: public; Owner: -
--

COPY request_container (id, sampler_id, distribution_id, address_id, containers_amount, reagent, pickup_from_lab, deliver, created_at, updated_at, phone) FROM stdin;
2	18	1	18	1	[{"name":"Lead", "amount":"100"}]	0	1	2017-12-21 08:36:06.721362	2017-12-21 08:36:06.721362	45644654
3	18	1	18	1	[]	0	1	2017-12-22 08:45:15.788056	2017-12-22 08:45:15.788056	45644654
1	18	1	18	2	[{"name":"Lead", "amount":"100"}]	0	1	2017-12-21 08:35:58.002611	2017-12-21 08:35:58.002611	45644654
\.


--
-- TOC entry 2798 (class 0 OID 0)
-- Dependencies: 196
-- Name: request_container_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('request_container_id_seq', 3, true);


--
-- TOC entry 2753 (class 0 OID 16968)
-- Dependencies: 232
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY role (id, name, created_at, updated_at, nickname, "position", menu_icon) FROM stdin;
1	Admin	2017-12-15 08:22:16.69997	2017-12-15 08:22:16.69997	\N	0	\N
2	Sampler	2017-12-15 08:22:21.748204	2017-12-15 08:22:21.748204	\N	0	\N
3	Manager	2017-12-15 08:22:33.995819	2017-12-15 08:22:33.995819	\N	0	\N
4	Lab-Tech	2017-12-15 08:22:40.756159	2017-12-15 08:22:40.756159	\N	0	\N
\.


--
-- TOC entry 2799 (class 0 OID 0)
-- Dependencies: 197
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('role_id_seq', 4, true);


--
-- TOC entry 2800 (class 0 OID 0)
-- Dependencies: 198
-- Name: sample_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sample_id_seq', 11, true);


--
-- TOC entry 2741 (class 0 OID 16671)
-- Dependencies: 220
-- Data for Name: sample_site_images; Type: TABLE DATA; Schema: public; Owner: -
--

COPY sample_site_images (id, address_id, created_at, updated_at, image_path, caption, image_name) FROM stdin;
17	19	2017-12-20 15:38:46.210156	2017-12-20 15:38:46.210156	http://hgtvhome.sndimg.com/content/dam/images/hgtv/fullset/2013/9/12/0/HKITC111_After-Yellow-Kitchen-Cabinets-Close_4x3.jpg.rend.hgtvcom.616.462.suffix/1400954077147.jpeg	Test Caption	\N
18	15	2018-01-08 07:25:42.549122	2018-01-08 07:25:42.549122	http://88.198.65.81/wateropsphp/uploads/img_chania8.jpg		img_chania8.jpg
19	15	2018-01-08 07:28:29.965107	2018-01-08 07:28:29.965107	http://88.198.65.81/wateropsphp/uploads/home_42.png	ASDas	home_42.png
20	15	2018-01-08 08:31:51.590871	2018-01-08 08:31:51.590871	http://88.198.65.81/wateropsphp/uploads/home_32.png		home_32.png
21	15	2018-01-08 08:32:32.787838	2018-01-08 08:32:32.787838	http://88.198.65.81/wateropsphp/uploads/home_32.png		home_32.png
22	15	2018-01-08 08:33:35.111526	2018-01-08 08:33:35.111526	http://88.198.65.81/wateropsphp/uploads/home_32.png		home_32.png
23	15	2018-01-08 08:35:06.636808	2018-01-08 08:35:06.636808	http://88.198.65.81/wateropsphp/uploads/home_3.png		home_3.png
16	18	2017-12-20 15:38:09.182969	2017-12-20 15:38:09.182969	https://www.google.de/imgres?imgurl=http%3A%2F%2F700billionreasons.com%2Fwp-content%2Fuploads%2Fbeautiful-house-elevation_227385.jpg&imgrefurl=http%3A%2F%2F700billionreasons.com%2Fmost-popular-beautiful-home-images-design%2Fbeautiful-house-elevation-5%2F&docid=0czv-3MOWBoUIM&tbnid=_iNXZIkjOHMZFM%3A&vet=10ahUKEwiS3NC13JjYAhVI4KQKHZUNCWQQMwi0ASgDMAM..i&w=1086&h=768&bih=662&biw=1366&q=house%20images%20gallery&ved=0ahUKEwiS3NC13JjYAhVI4KQKHZUNCWQQMwi0ASgDMAM&iact=mrc&uact=8	Test Caption	\N
15	17	2017-12-20 15:37:25.917882	2017-12-20 15:37:25.917882	https://www.google.de/imgres?imgurl=http%3A%2F%2F700billionreasons.com%2Fwp-content%2Fuploads%2Fbeautiful-house-elevation_227385.jpg&imgrefurl=http%3A%2F%2F700billionreasons.com%2Fmost-popular-beautiful-home-images-design%2Fbeautiful-house-elevation-5%2F&docid=0czv-3MOWBoUIM&tbnid=_iNXZIkjOHMZFM%3A&vet=10ahUKEwiS3NC13JjYAhVI4KQKHZUNCWQQMwi0ASgDMAM..i&w=1086&h=768&bih=662&biw=1366&q=house%20images%20gallery&ved=0ahUKEwiS3NC13JjYAhVI4KQKHZUNCWQQMwi0ASgDMAM&iact=mrc&uact=8	Test Caption	\N
14	16	2017-12-20 15:36:34.006377	2017-12-20 15:36:34.006377	http://www.ikea.com/ms/en_US/media/choice_entrance/20181_bacd01.jpg	Test Caption	\N
13	15	2017-12-20 15:35:15.916772	2017-12-20 15:35:15.916772	http://www.ikea.com/ms/en_US/media/choice_entrance/20181_bacd01.jpg	Test Caption	\N
9	20	2017-12-20 12:18:15.899198	2017-12-20 12:18:15.899198	http://www.ikea.com/ms/en_US/media/choice_entrance/20181_bacd01.jpg	Test Caption	\N
8	20	2017-12-20 12:18:15.883167	2017-12-20 12:18:15.883167	http://hgtvhome.sndimg.com/content/dam/images/hgtv/fullset/2013/9/12/0/HKITC111_After-Yellow-Kitchen-Cabinets-Close_4x3.jpg.rend.hgtvcom.616.462.suffix/1400954077147.jpeg	Test Caption	\N
7	20	2017-12-20 12:16:18.999621	2017-12-20 12:16:18.999621	https://www.google.de/imgres?imgurl=http%3A%2F%2F700billionreasons.com%2Fwp-content%2Fuploads%2Fbeautiful-house-elevation_227385.jpg&imgrefurl=http%3A%2F%2F700billionreasons.com%2Fmost-popular-beautiful-home-images-design%2Fbeautiful-house-elevation-5%2F&docid=0czv-3MOWBoUIM&tbnid=_iNXZIkjOHMZFM%3A&vet=10ahUKEwiS3NC13JjYAhVI4KQKHZUNCWQQMwi0ASgDMAM..i&w=1086&h=768&bih=662&biw=1366&q=house%20images%20gallery&ved=0ahUKEwiS3NC13JjYAhVI4KQKHZUNCWQQMwi0ASgDMAM&iact=mrc&uact=8	Test Caption	\N
\.


--
-- TOC entry 2801 (class 0 OID 0)
-- Dependencies: 231
-- Name: sample_site_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sample_site_images_id_seq', 23, true);


--
-- TOC entry 2742 (class 0 OID 16679)
-- Dependencies: 221
-- Data for Name: sample_sites_address; Type: TABLE DATA; Schema: public; Owner: -
--

COPY sample_sites_address (id, latitude, longitude, street_1, street_2, city, state, zip, created_at, updated_at, type_of_sampling_location, location_samplesite_used, distribution_id) FROM stdin;
65	38.3979614	-75.5551078	Bennett	Rd	MD	Salisbury	21804	2018-01-09 11:42:38.695685	2018-01-09 11:42:38.695685	NA	NA	47
66	38.4001474	-75.6324470	Salisbury	Blvd	MD	Salisbury	21801	2018-01-09 11:42:39.727331	2018-01-09 11:42:39.727331	NA	NA	47
15	38.3985030	-75.5515400	30591	Bennett Rd	Salisbury	MD	21804	2017-12-19 15:12:04.762348	2017-12-19 15:12:04.762348	location1	used1	1
67	38.3468732	-75.6083366	Camden	Ave	MD	Salisbury	21801	2018-01-09 11:42:39.836641	2018-01-09 11:42:39.836641	NA	NA	47
16	38.3427220	-75.6057480	1306	Salisbury Blvd	Salisbury	MD	21804	2017-12-19 15:12:05.231135	2017-12-19 15:12:05.231135	Location2	Used2	1
68	38.3979614	-75.5551078	Bennett	Rd	MD	Salisbury	21804	2018-01-09 11:42:49.913718	2018-01-09 11:42:49.913718	NA	NA	47
69	38.4001474	-75.6324470	Salisbury	Blvd	MD	Salisbury	21801	2018-01-09 11:42:50.116896	2018-01-09 11:42:50.116896	NA	NA	47
70	38.3468732	-75.6083366	Camden	Ave	MD	Salisbury	21801	2018-01-09 11:42:50.22627	2018-01-09 11:42:50.22627	NA	NA	47
17	38.3442370	-75.6054920	1101	Camden Ave	Salisbury	MD	21804	2017-12-19 15:12:44.157337	2017-12-19 15:12:44.157337	location1	used1	1
18	38.3398710	-75.6076880	1413	Wesley Dr	Salisbury	MD	21801	2017-12-19 15:12:44.313718	2017-12-19 15:12:44.313718	Location2	Used2	1
19	38.3441000	-75.6011880	1301	Wayne St	Salisbury	MD	21804	2017-12-20 07:49:05.997232	2017-12-20 07:49:05.997232	Location2	Used2	1
20	28.6306630	77.3820730	D 64	Sector63	Noida	UP	201301	2017-12-20 07:53:24.955775	2017-12-20 07:53:24.955775	\N	Used	1
21	28.6249200	77.3832930	D-63	Sector 63	Uttar Pradesh	Noida	201010	2017-12-21 10:44:21.142836	2017-12-21 10:44:21.142836	Industrial Area	50Km	1
22	28.5915611	77.3352227	D-65	Sec 64	UP	Noida	201301	2017-12-21 10:44:21.720959	2017-12-21 10:44:21.720959	IT Hub	20Km	1
23	26.8877658	80.9551859	D-64	Sector 64	Uttar Pradesh	Noida	102020	2017-12-21 11:02:46.97077	2017-12-21 11:02:46.97077	Industrial Are	50Km	1
24	28.6307754	77.3821164	D-65	Sctor 63	UP	Noida	201010	2017-12-21 11:02:47.61139	2017-12-21 11:02:47.61139	IT Hub	20Km	1
25	28.6118920	77.3762261	D-64	Sector 64	Uttar Pradesh	Noida	102020	2017-12-21 11:05:20.497084	2017-12-21 11:05:20.497084	Industrial Are	50Km	1
26	28.6609173	77.3410569	D-65	Sctor 63	UP	Noida	201010	2017-12-21 11:05:21.044007	2017-12-21 11:05:21.044007	IT Hub	20Km	1
27	28.6306634	77.3820725	D-64	secot 63	Uttar Pradesh	Noida	201301	2017-12-21 11:21:03.737831	2017-12-21 11:21:03.737831	Industrial Are	20km used	1
28	28.5355161	77.3910265	D-65	Sector 64	U.P	Noida	201302	2017-12-21 11:21:04.612828	2017-12-21 11:21:04.612828	IT Hub	10Km	1
29	28.5821195	77.3266991	D-64	secot 63	Uttar Pradesh	Noida	201301	2017-12-21 11:22:16.600621	2017-12-21 11:22:16.600621	Industrial Are	20km used	1
30	28.6307754	77.3821164	D-65	Sector 64	U.P	Noida	201302	2017-12-21 11:22:17.28817	2017-12-21 11:22:17.28817	IT Hub	10Km	1
31	28.6194550	77.3822920	D-64	secot 63	Uttar Pradesh	Noida	201301	2017-12-21 11:22:54.344459	2017-12-21 11:22:54.344459	Industrial Are	20km used	1
32	28.6307754	77.3821164	D-65	Sector 64	U.P	Noida	201302	2017-12-21 11:22:54.469451	2017-12-21 11:22:54.469451	IT Hub	10Km	1
36	28.6306634	77.3820725	D-64	secot 63	Uttar Pradesh	Noida	201301	2017-12-21 11:29:37.567862	2017-12-21 11:29:37.567862	Industrial Are	20km used	1
37	28.6307754	77.3821164	D-65	Sector 64	U.P	Noida	201302	2017-12-21 11:29:38.052236	2017-12-21 11:29:38.052236	IT Hub	10Km	1
38	28.5821195	77.3266991	D-65	Sector 66	Uttar Pradesh	Noida	201301	2017-12-21 11:29:38.895984	2017-12-21 11:29:38.895984	Software	100Km	1
40	28.6307754	77.3821164	D 65	Sector 63	Noida	Uttar Pradesh	201301	2017-12-22 08:27:34.519285	2017-12-22 08:27:34.519285	\N	\N	1
41	28.6306390	77.3824978	D-66	Sector 63	Noida	Uttar Pradesh	201301	2017-12-27 11:46:27.920077	2017-12-27 11:46:27.920077			1
42	28.6306390	77.3824978	D-66	Sector 63	Noida	Uttar Pradesh	201301	2017-12-27 11:49:39.755142	2017-12-27 11:49:39.755142			1
43	28.5821195	77.3266991	D-66	Sector 63	Noida	Uttar Pradesh	201301	2017-12-27 11:54:26.578404	2017-12-27 11:54:26.578404			1
44	28.5821195	77.3266991	D-66	Sector 63	Noida	Uttar Pradesh	201301	2017-12-27 11:56:52.468421	2017-12-27 11:56:52.468421			1
45	28.6306390	77.3824978	D-66	Sector 63	Noida	Uttar Pradesh	201301	2017-12-27 12:04:48.143168	2017-12-27 12:04:48.143168			1
46	28.6609173	77.3410569	D- 65	Sector 63	Noida	Uttar Pradesh	201010	2018-01-03 08:03:14.188958	2018-01-03 08:03:14.188958			1
47	28.6306634	77.3820725	D 64	Sec 63	Noida	UP	201301	2018-01-04 12:08:41.200667	2018-01-04 12:08:41.200667	ABC	EA	35
48	28.5821195	77.3266991	D 61	Sector 63	Noida	UP	201301	2018-01-04 12:08:42.027713	2018-01-04 12:08:42.027713	ABC	EA	35
49	28.5821195	77.3266991	D 64	Sector 63	Noida	UP	201301	2018-01-04 12:31:51.057366	2018-01-04 12:31:51.057366	qwe	rty	35
50	28.6306634	77.3820725	D 62	Sector 63	Noida	UP	201301	2018-01-04 12:31:51.829167	2018-01-04 12:31:51.829167	qwerty	ops	35
51	28.6255162	77.3829160	D 62	Sector 63	Noida	UP	201301	2018-01-04 12:32:35.597809	2018-01-04 12:32:35.597809	qwerty	ops	35
52	28.5821195	77.3266991	D 64	Sector 63	Noida	UP	201301	2018-01-04 12:47:38.287908	2018-01-04 12:47:38.287908			35
53	28.5821195	77.3266991	D 64	Sector 63	Noida	UP	201301	2018-01-04 12:54:36.159184	2018-01-04 12:54:36.159184			35
54	28.6306634	77.3820725	D 64	Sector 63	UP	Noida	201301	2018-01-08 13:19:10.940057	2018-01-08 13:19:10.940057	a	b	44
55	28.6306634	77.3820725	D 64	Sector 63	UP	Noida	201301	2018-01-08 13:19:10.940057	2018-01-08 13:19:10.940057	a	b	44
56	28.6307168	77.3820777	D 73	Sector 63	UP	Noida	201301	2018-01-08 13:19:11.674881	2018-01-08 13:19:11.674881	v	q	44
57	28.5821195	77.3266991	C 64	Sector 63	UP	Noida	201301	2018-01-08 13:23:40.673198	2018-01-08 13:23:40.673198	a	b	44
58	28.6307168	77.3820777	C 73	Sector 63	UP	Noida	201301	2018-01-08 13:23:41.274994	2018-01-08 13:23:41.274994	v	q	44
59	38.3606736	-75.5993692	Bennett	Rd	MD	Salisbury	21804	2018-01-09 11:42:30.727037	2018-01-09 11:42:30.727037	NA	NA	47
60	38.4001474	-75.6324470	Salisbury	Blvd	MD	Salisbury	21801	2018-01-09 11:42:31.424737	2018-01-09 11:42:31.424737	NA	NA	47
61	38.3468732	-75.6083366	Camden	Ave	MD	Salisbury	21801	2018-01-09 11:42:32.085764	2018-01-09 11:42:32.085764	NA	NA	47
62	38.3979614	-75.5551078	Bennett	Rd	MD	Salisbury	21804	2018-01-09 11:42:37.898275	2018-01-09 11:42:37.898275	NA	NA	47
63	38.3928226	-75.5746475	Salisbury	Blvd	MD	Salisbury	21801	2018-01-09 11:42:38.53946	2018-01-09 11:42:38.53946	NA	NA	47
64	38.3468732	-75.6083366	Camden	Ave	MD	Salisbury	21801	2018-01-09 11:42:38.633164	2018-01-09 11:42:38.633164	NA	NA	47
73	38.3468732	-75.6083366	Camden	Ave	MD	Salisbury	21801	2018-01-09 14:35:23.772748	2018-01-09 14:35:23.772748	NA	NA	2
74	38.3404410	-75.6078698	Wesleyi	Dri	MD	Salisbury	21801	2018-01-09 14:35:23.888753	2018-01-09 14:35:23.888753	NA	NA	2
75	38.3468732	-75.6083366	Camden	Ave	MD	Salisbury	21801	2018-01-09 14:42:41.783455	2018-01-09 14:42:41.783455			2
76	51.5244728	-0.0879232	49	Featherstone Street	London	London	EC1Y 8SY	2018-01-12 07:08:26.119444	2018-01-12 07:08:26.119444	\N	\N	56
\.


--
-- TOC entry 2802 (class 0 OID 0)
-- Dependencies: 199
-- Name: sample_sites_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sample_sites_address_id_seq', 77, true);


--
-- TOC entry 2743 (class 0 OID 16690)
-- Dependencies: 222
-- Data for Name: sample_sites_notes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY sample_sites_notes (id, sample_sites_address_id, notes, created_at, updated_at) FROM stdin;
11	16	Hello World Hello	2017-12-19 15:12:05.231135	2017-12-19 15:12:05.231135
10	15	Hello World1	2017-12-19 15:12:05.231135	2017-12-19 15:12:05.231135
12	17	Hello Hello2	2017-12-19 15:12:44.313718	2017-12-19 15:12:44.313718
13	18	Sample notes3	2017-12-19 15:12:44.313718	2017-12-19 15:12:44.313718
14	20	Test note4	2017-12-20 08:28:30.272173	2017-12-20 08:28:30.272173
15	36	Clorine Sample	2017-12-21 11:29:38.895984	2017-12-21 11:29:38.895984
16	37	lead	2017-12-21 11:29:38.895984	2017-12-21 11:29:38.895984
17	38	dsfsdf	2017-12-21 11:29:38.911552	2017-12-21 11:29:38.911552
19	20	test	2017-12-21 14:04:44.308609	2017-12-21 14:04:44.308609
20	20	test2	2017-12-21 14:12:27.291201	2017-12-21 14:12:27.291201
21	40		2017-12-22 08:27:34.550511	2017-12-22 08:27:34.550511
22	17	Save new note.	2017-12-22 10:40:51.199231	2017-12-22 10:40:51.199231
23	17	Owner Not Available.	2017-12-22 10:45:55.051222	2017-12-22 10:45:55.051222
24	41		2017-12-27 11:46:27.935703	2017-12-27 11:46:27.935703
25	42		2017-12-27 11:49:39.770713	2017-12-27 11:49:39.770713
26	43		2017-12-27 11:54:26.656529	2017-12-27 11:54:26.656529
27	44	Details:	2017-12-27 11:56:52.48399	2017-12-27 11:56:52.48399
28	45	Details:1	2017-12-27 12:04:48.15874	2017-12-27 12:04:48.15874
29	46	test Notes	2018-01-03 08:03:14.204585	2018-01-03 08:03:14.204585
30	49		2018-01-04 12:31:51.851214	2018-01-04 12:31:51.851214
31	50		2018-01-04 12:31:51.861152	2018-01-04 12:31:51.861152
32	51	Hello World	2018-01-04 12:32:35.597809	2018-01-04 12:32:35.597809
33	52	Lorem Ipsum	2018-01-04 12:47:38.300908	2018-01-04 12:47:38.300908
34	53	32r23r refgreg grbgrbtrgb	2018-01-04 12:54:36.159184	2018-01-04 12:54:36.159184
35	20	Test note 5	2018-01-04 14:21:59.646822	2018-01-04 14:21:59.646822
36	54		2018-01-08 13:19:11.690448	2018-01-08 13:19:11.690448
37	56		2018-01-08 13:19:11.690448	2018-01-08 13:19:11.690448
38	57		2018-01-08 13:23:41.274994	2018-01-08 13:23:41.274994
39	58		2018-01-08 13:23:41.290569	2018-01-08 13:23:41.290569
40	59	Do not play with the dog	2018-01-09 11:42:32.085764	2018-01-09 11:42:32.085764
41	60	I killed it	2018-01-09 11:42:32.085764	2018-01-09 11:42:32.085764
42	61	Do not play with the dog	2018-01-09 11:42:32.085764	2018-01-09 11:42:32.085764
43	62	Do not play with the dog	2018-01-09 11:42:38.648789	2018-01-09 11:42:38.648789
44	63	I killed it	2018-01-09 11:42:38.648789	2018-01-09 11:42:38.648789
45	64	Do not play with the dog	2018-01-09 11:42:38.648789	2018-01-09 11:42:38.648789
46	65	Do not play with the dog	2018-01-09 11:42:39.836641	2018-01-09 11:42:39.836641
47	66	I killed it	2018-01-09 11:42:39.836641	2018-01-09 11:42:39.836641
48	67	Do not play with the dog	2018-01-09 11:42:39.836641	2018-01-09 11:42:39.836641
49	68	Do not play with the dog	2018-01-09 11:42:50.22627	2018-01-09 11:42:50.22627
50	69	I killed it	2018-01-09 11:42:50.22627	2018-01-09 11:42:50.22627
51	70	Do not play with the dog	2018-01-09 11:42:50.22627	2018-01-09 11:42:50.22627
54	73	Do not play with the dog	2018-01-09 14:35:23.888753	2018-01-09 14:35:23.888753
55	74	I killed it	2018-01-09 14:35:23.888753	2018-01-09 14:35:23.888753
56	75	Do not play with the dogt	2018-01-09 14:42:41.791793	2018-01-09 14:42:41.791793
57	76	Test notes	2018-01-12 07:08:26.135014	2018-01-12 07:08:26.135014
\.


--
-- TOC entry 2803 (class 0 OID 0)
-- Dependencies: 200
-- Name: sample_sites_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sample_sites_notes_id_seq', 58, true);


--
-- TOC entry 2744 (class 0 OID 16699)
-- Dependencies: 223
-- Data for Name: sample_sites_owner; Type: TABLE DATA; Schema: public; Owner: -
--

COPY sample_sites_owner (id, owner_firstname, owner_lastname, owner_contact_number, updated_at, created_at, sample_sites_address_id) FROM stdin;
10	Vijay	kumar	7838043535	2017-12-19 15:12:05.231135	2017-12-19 15:12:05.231135	15
11	Hassan	Ali	78380435545	2017-12-19 15:12:05.231135	2017-12-19 15:12:05.231135	16
12	Vijay	kumar	7838043535	2017-12-19 15:12:44.313718	2017-12-19 15:12:44.313718	17
13	Hassan	Ali	78380435545	2017-12-19 15:12:44.313718	2017-12-19 15:12:44.313718	18
17	Shekhar	Chandra	398234923423	2017-12-20 09:44:20.608569	2017-12-20 09:44:20.608569	20
18	Abhishek	Kumar	121211212121	2017-12-20 09:45:18.670737	2017-12-20 09:45:18.670737	20
19	Max	Payne	1278272323	2017-12-20 09:57:12.335654	2017-12-20 09:57:12.335654	20
14	Shashank	Trivedi	1234567890	2017-12-20 08:29:10.80828	2017-12-20 08:29:10.80828	20
20	Ashish	 verma	7838043535	2017-12-21 11:29:38.895984	2017-12-21 11:29:38.895984	36
21	Vijay	Kumar	445151	2017-12-21 11:29:38.895984	2017-12-21 11:29:38.895984	37
22	Hassan	Ali	54541545646	2017-12-21 11:29:38.895984	2017-12-21 11:29:38.895984	38
24	Shekhar	Bhardwak	9990882358	2017-12-22 08:08:04.08487	2017-12-22 08:08:04.08487	17
25	Vinay 	Singh	1234567894	2017-12-22 08:27:34.534879	2017-12-22 08:27:34.534879	40
16	Sultana	KP	394234234234	2017-12-20 09:42:42.264659	2017-12-20 09:42:42.264659	20
26	Ashish	Verma	7838043535	2018-01-03 08:03:14.188958	2018-01-03 08:03:14.188958	46
27	Hassan	Ali	1234567890	2018-01-04 12:08:42.029668	2018-01-04 12:08:42.029668	47
28	Ashish	Kumar	1234567890	2018-01-04 12:08:42.051728	2018-01-04 12:08:42.051728	48
29	Shekhar	Bhardwaj	1234567890	2018-01-04 12:31:51.830133	2018-01-04 12:31:51.830133	49
30	Vijay	Kumar	1234567890	2018-01-04 12:31:51.849144	2018-01-04 12:31:51.849144	50
31	Vijay	Kumar	1234567890	2018-01-04 12:32:35.597809	2018-01-04 12:32:35.597809	51
32	Nishant	Garg	1234567890	2018-01-04 12:47:38.298911	2018-01-04 12:47:38.298911	52
33	Shekhar	Bhardwaj	123444555555	2018-01-04 12:54:36.159184	2018-01-04 12:54:36.159184	53
34	Kelvin	Jackson	1234567890	2018-01-04 14:22:47.13105	2018-01-04 14:22:47.13105	20
35	Lee	McTester	123334455566	2018-01-08 13:19:11.674881	2018-01-08 13:19:11.674881	54
36	Timon	Clark	123334455566	2018-01-08 13:19:11.674881	2018-01-08 13:19:11.674881	56
37	Max	McTester	123334455566	2018-01-08 13:23:41.274994	2018-01-08 13:23:41.274994	57
38	Tiger	Schroff	123334455566	2018-01-08 13:23:41.274994	2018-01-08 13:23:41.274994	58
39	Fred	Douglas	1234567890	2018-01-09 11:42:32.085764	2018-01-09 11:42:32.085764	59
40	Dick	Penson	1234567890	2018-01-09 11:42:32.085764	2018-01-09 11:42:32.085764	60
41	Abe	Lincoln	1234567890	2018-01-09 11:42:32.085764	2018-01-09 11:42:32.085764	61
42	Fred	Douglas	1234567890	2018-01-09 11:42:38.648789	2018-01-09 11:42:38.648789	62
43	Dick	Penson	1234567890	2018-01-09 11:42:38.648789	2018-01-09 11:42:38.648789	63
44	Abe	Lincoln	1234567890	2018-01-09 11:42:38.648789	2018-01-09 11:42:38.648789	64
45	Fred	Douglas	1234567890	2018-01-09 11:42:39.836641	2018-01-09 11:42:39.836641	65
46	Dick	Penson	1234567890	2018-01-09 11:42:39.836641	2018-01-09 11:42:39.836641	66
47	Abe	Lincoln	1234567890	2018-01-09 11:42:39.836641	2018-01-09 11:42:39.836641	67
48	Fred	Douglas	1234567890	2018-01-09 11:42:50.22627	2018-01-09 11:42:50.22627	68
49	Dick	Penson	1234567890	2018-01-09 11:42:50.22627	2018-01-09 11:42:50.22627	69
50	Abe	Lincoln	1234567890	2018-01-09 11:42:50.22627	2018-01-09 11:42:50.22627	70
53	Sam	Wilson	555-555-5555	2018-01-09 14:35:23.888753	2018-01-09 14:35:23.888753	73
54	Hassan	Ali	555-555-5555	2018-01-09 14:35:23.888753	2018-01-09 14:35:23.888753	74
55	Sam	Wilson	555-555-5555	2018-01-09 14:42:41.791793	2018-01-09 14:42:41.791793	75
56	Walter	Brown	1234567890	2018-01-12 07:08:26.119444	2018-01-12 07:08:26.119444	76
\.


--
-- TOC entry 2804 (class 0 OID 0)
-- Dependencies: 201
-- Name: sample_sites_owner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sample_sites_owner_id_seq', 57, true);


--
-- TOC entry 2745 (class 0 OID 16708)
-- Dependencies: 224
-- Data for Name: samples; Type: TABLE DATA; Schema: public; Owner: -
--

COPY samples (id, container_id, address_id, user_id, fixture, temperature, turbidity, chlorine, ph_level, delete_type, created_at, updated_at, task_id, coliform) FROM stdin;
6	3	20	18	Bathroom	40	0.5	2	5	0	2017-12-21 08:13:11.252622	2017-12-21 08:13:11.252622	8	t
5	3	20	18	Kitchen Sink	60	1	3	6	0	2017-12-21 08:12:08.599595	2017-12-21 08:12:08.599595	8	t
7	5	20	7	test	1	1	2	2	0	2017-12-26 08:48:57.072562	2017-12-26 08:48:57.072562	7	t
3	3	20	7	Bath Room	40	0.5	2	5	0	2017-12-20 08:37:43.103778	2017-12-20 08:37:43.103778	12	t
2	3	20	7	Kitchen Sink	60	1	3	6	1	2017-12-20 08:37:09.423019	2017-12-20 08:37:09.423019	13	f
11	3	20	4	House	5	1	1	4	0	2018-01-03 13:23:43.389378	2018-01-03 13:23:43.389378	23	f
\.


--
-- TOC entry 2746 (class 0 OID 16718)
-- Dependencies: 225
-- Data for Name: status; Type: TABLE DATA; Schema: public; Owner: -
--

COPY status (id, status, created_at, updated_at) FROM stdin;
2	Submitted	2017-12-20 06:57:39.99512	2017-12-20 06:57:39.99512
1	Completed	2017-12-20 06:54:14.946474	2017-12-20 06:54:14.946474
3	Sample Taken	2017-12-20 06:57:55.557487	2017-12-20 06:57:55.557487
4	Rejected	2017-12-20 06:58:01.651215	2017-12-20 06:58:01.651215
5	Used	2017-12-20 06:58:08.951986	2017-12-20 06:58:08.951986
6	Not Used	2017-12-20 06:58:23.963111	2017-12-20 06:58:23.963111
7	Expired	2017-12-20 06:58:34.806827	2017-12-20 06:58:34.806827
8	Assigned	2017-12-22 15:02:55.325004	2017-12-22 15:02:55.325004
9	Ready	2018-01-02 07:19:32.917777	2018-01-02 07:19:32.917777
10	Incubating	2018-01-02 07:19:47.33374	2018-01-02 07:19:47.33374
11	Pass	2018-01-08 09:22:42.504872	2018-01-08 09:22:42.504872
12	Currently Out	2018-01-08 09:23:22.802401	2018-01-08 09:23:22.802401
13	Fail	2018-01-08 09:24:26.219194	2018-01-08 09:24:26.219194
\.


--
-- TOC entry 2805 (class 0 OID 0)
-- Dependencies: 202
-- Name: status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('status_id_seq', 14, true);


--
-- TOC entry 2747 (class 0 OID 16727)
-- Dependencies: 226
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: -
--

COPY task (id, user_id, assign_by, address_id, assign_date, schedule_date, completed_date, created_at, updated_at, total_sample, sample_required, status, coliform, copper, metals, emergency_sample, phone_no, is_delete, emergency_type, comments, distribution_id) FROM stdin;
5	4	4	15	2017-10-10	2017-12-26	2017-05-26	2017-12-19 15:16:10.718845	2017-12-19 15:16:10.718845	\N	\N	1	f	f	f	f	\N	1	\N	\N	1
6	4	4	16	2017-10-11	2017-12-26	2017-06-26	2017-12-19 15:17:19.903415	2017-12-19 15:17:19.903415	\N	\N	1	f	f	f	f	\N	0	\N	\N	1
7	4	4	17	2018-05-09	2018-12-26	2017-07-26	2017-12-19 15:18:23.484369	2017-12-19 15:18:23.484369	\N	\N	1	f	t	f	f	\N	0	\N	\N	1
8	4	4	20	2017-15-20	2017-12-26	2017-08-26	2017-12-20 08:30:11.137382	2017-12-20 08:30:11.137382	\N	\N	1	t	t	t	t	\N	0	\N	\N	1
11	18	4	15	2017-10-10	2017-12-26	2017-09-26	2017-12-21 08:14:40.985352	2017-12-21 08:14:40.985352	\N	\N	1	f	f	f	f	\N	0	\N	\N	1
12	18	4	16	2017-10-11	2018-12-21	2017-10-26	2017-12-21 08:15:39.188965	2017-12-21 08:15:39.188965	\N	\N	1	f	t	f	f	\N	0	\N	\N	1
13	18	4	17	2017-05-09	2017-12-26	2017-11-26	2017-12-21 08:16:29.866552	2017-12-21 08:16:29.866552	\N	\N	1	f	f	f	t	\N	0	\N	\N	1
14	18	4	20	2017-05-09	2017-12-22	2018-01-30	2017-12-21 08:17:31.195286	2017-12-21 08:17:31.195286	\N	\N	1	t	t	t	f	\N	0	\N	\N	1
16	7	4	20	2017-05-09	2017-12-22	2018-02-26	2017-12-22 11:57:41.372694	2017-12-22 11:57:41.372694	\N	\N	1	t	t	t	f	\N	1	\N	\N	1
17	7	4	21	2017-05-10	2017-12-15	2018-03-26	2017-12-22 11:59:11.570902	2017-12-22 11:59:11.570902	\N	\N	1	f	t	t	t	\N	1	\N	\N	1
19	18	4	40	2017-12-27	2017-12-27	2016-12-26	2017-01-01 11:29:53.85833	2017-12-27 11:29:53.85833	100	1	8	f	f	f	t	\N	0	1	sdfsdf	1
20	18	4	41	2017-12-27	2017-12-13	2016-11-26	2017-01-30 11:46:27.920077	2017-12-27 11:46:27.920077	200	1	8	f	f	f	t	\N	0	1	Additional Comments:	1
21	18	4	42	2017-12-27	2017-01-05	2017-12-26	2017-12-27 11:49:39.770713	2017-12-27 11:49:39.770713	200	1	8	f	f	f	t	\N	0	1	Additional Comments:	1
22	18	4	43	2017-12-27	2017-01-02	2017-05-26	2017-12-27 11:54:26.656529	2017-12-27 11:54:26.656529	200	1	8	f	f	f	t	\N	0	1	Additional Comments:	1
23	7	4	44	2017-12-27	2017-01-02	2017-06-26	2017-12-27 11:56:52.48399	2017-12-27 11:56:52.48399	333	1	8	f	f	f	t	\N	0	2	additional comment update	1
24	18	4	45	2017-12-27	2018-01-01	2017-08-26	2017-12-27 12:04:48.15874	2017-12-27 12:04:48.15874	200	1	8	f	f	f	t	\N	0	1	Additional Comments:2	1
25	18	4	45	2016-05-10	2018-01-02	2017-09-26	2018-01-03 08:30:53.23239	2018-01-03 08:30:53.23239	10	1	7	f	t	f	t	\N	0	1	test	2
27	18	4	45	2017-10-20	2017-12-30	2017-10-26	2018-01-03 09:09:22.543886	2018-01-03 09:09:22.543886	1	1	8	f	t	t	t	\N	0	1	test 2	2
\.


--
-- TOC entry 2806 (class 0 OID 0)
-- Dependencies: 203
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('task_id_seq', 29, true);


--
-- TOC entry 2728 (class 0 OID 16442)
-- Dependencies: 207
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "user" (id, username, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, confirmation_token, confirmed_at, confirmation_sent_at, unconfirmed_email, failed_attempts, unlock_token, locked_at, created_at, updated_at, interface_preference, firstname, lastname, active, started_date, termination_date, access_token, token_expire_time, middlename, phone_number, operator_license_no, phone_number_2, license_expires, distribution_system_id, license_grade_level, permission_level, roles, systems, license_id, logged_in) FROM stdin;
30	jason	Jason@ops.net	e10adc3949ba59abbe56e057f20f883e	\N	\N	2018-01-11 07:54:47.567336	0	2018-01-11 07:54:47.567336	2018-01-11 07:54:47.567336	\N	\N	\N	2018-01-11 07:54:47.567336	2018-01-11 07:54:47.567336	\N	0	\N	2018-01-11 07:54:47.567336	2018-01-11 07:54:47.567336	2018-01-11 07:54:47.567336	0	Jason	Bays	t	2018-01-11	2028-01-11	\N	\N		7838043535	5555555555		2018-01-31T06:44:00.000Z	2			\N	\N	1	f
14		shashank.tyagi@ops.net	e10adc3949ba59abbe56e057f20f883e	\N	\N	2017-12-19 13:19:59.317473	0	2017-12-19 13:19:59.317473	2017-12-19 13:19:59.317473	\N	\N	\N	2017-12-19 13:19:59.317473	2017-12-19 13:19:59.317473	\N	0	\N	2017-12-19 13:19:59.317473	2017-12-19 13:19:59.317473	2017-12-19 13:19:59.317473	0	Shashank	Tyagi	t	2017-12-19	2027-12-19	\N	\N		9049434342	1234-2232-1235-3454		2019-05-14	1			\N	\N	1	\N
28	rogers@123	rogers@o-p-s.net	e10adc3949ba59abbe56e057f20f883e	\N	\N	2018-01-11 07:08:49.280772	0	2018-01-11 07:08:49.280772	2018-01-11 07:08:49.280772	\N	\N	\N	2018-01-11 07:08:49.280772	2018-01-11 07:08:49.280772	\N	0	\N	2018-01-11 07:08:49.280772	2018-01-11 07:08:49.280772	2018-01-11 07:08:49.280772	0	Rogers	George	t	2018-01-11	2031-01-11	\N	\N		555-555-5555	DL-102030		2019-02-26T06:05:00.000Z	2			\N	\N	1	f
12	admin2	admin2@loginworks.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2017-12-18 15:40:25.185514	0	2017-12-18 15:40:25.185514	2017-12-18 15:40:25.185514	\N	\N	\N	2017-12-18 15:40:25.185514	2017-12-18 15:40:25.185514	\N	0	\N	2017-12-18 15:40:25.185514	2017-12-18 15:40:25.185514	2017-12-18 15:40:25.185514	0	testq	 kumar	t	2017-12-18	2027-12-18	\N	\N		1234567893	DL-201010		2017-12-21	1			\N	\N	1	\N
13		shekhar1@loginworks.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2017-12-19 10:35:27.462546	0	2017-12-19 10:35:27.462546	2017-12-19 10:35:27.462546	\N	\N	\N	2017-12-19 10:35:27.462546	2017-12-19 10:35:27.462546	\N	0	\N	2017-12-19 10:35:27.462546	2017-12-19 10:35:27.462546	2017-12-19 10:35:27.462546	0	Shekhar	Bhardwaj	t	2017-12-19	2027-12-19	5a39fd21cf0f3i81e4nFnGW1DZ3BxaLpS3v9jvFK3Lp	2017-12-20 15:03:13		1234567890	123-321-654		2018-03-31	1			\N	\N	1	\N
16		rohan@ops.net	e10adc3949ba59abbe56e057f20f883e	\N	\N	2017-12-19 13:41:56.826632	0	2017-12-19 13:41:56.826632	2017-12-19 13:41:56.826632	\N	\N	\N	2017-12-19 13:41:56.826632	2017-12-19 13:41:56.826632	\N	0	\N	2017-12-19 13:41:56.826632	2017-12-19 13:41:56.826632	2017-12-19 13:41:56.826632	0	Rojhan	Kakkar	t	2017-12-19	2027-12-19	\N	\N		121212121212	1234-2232-1235-3454		2019-08-13	1			\N	\N	1	\N
15		ritika.gupta@loginworks.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2017-12-19 13:29:30.671659	0	2017-12-19 13:29:30.671659	2017-12-19 13:29:30.671659	\N	\N	\N	2017-12-19 13:29:30.671659	2017-12-19 13:29:30.671659	\N	0	\N	2017-12-19 13:29:30.671659	2017-12-19 13:29:30.671659	2017-12-21 12:04:56.219265	0	Ritika	Gupta	t	2017-12-19	2027-12-19	\N	\N		90494343420	1234-2232-1235-3454		2018-02-28	1			\N	\N	1	\N
17		shushi@ops.net	e10adc3949ba59abbe56e057f20f883e	\N	\N	2017-12-19 13:43:35.687737	0	2017-12-19 13:43:35.687737	2017-12-19 13:43:35.687737	\N	\N	\N	2017-12-19 13:43:35.687737	2017-12-19 13:43:35.687737	\N	0	\N	2017-12-19 13:43:35.687737	2017-12-19 13:43:35.687737	2017-12-19 13:43:35.687737	0	Shushi	Baichi	t	2017-12-19	2027-12-19	\N	\N		9049434342	1234-2232-1235-3454		2017-08-10	1			\N	\N	1	\N
26	milly@123	\N		\N	\N	2018-01-09 14:15:37.191873	0	2018-01-09 14:15:37.191873	2018-01-09 14:15:37.191873	\N	\N	\N	2018-01-09 14:15:37.191873	2018-01-09 14:15:37.191873	\N	0	\N	2018-01-09 14:15:37.191873	2018-01-09 14:15:37.191873	2018-01-09 14:15:37.191873	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f
6	tim	timothy.gantzhorn@o-p-s.net	e10adc3949ba59abbe56e057f20f883e	\N	\N	2017-12-18 13:52:04.33031	0	2017-12-18 13:52:04.33031	2017-12-18 13:52:04.33031	\N	\N	\N	2017-12-18 13:52:04.33031	2017-12-18 13:52:04.33031	\N	0	\N	2017-12-18 13:52:04.33031	2017-12-18 13:52:04.33031	2017-12-18 13:52:04.33031	0	Tim	McTester	t	2017-12-18	2018-12-18	5a3a3ba9da2b52ihYGtEGEGSVgG48twaMVYT524UeqY	2017-12-20 19:30:01		1233444445555	122-444-000	1233444445555	2018-04-30T12:50:00.000Z	1			\N	\N	1	\N
18		vikas.dhama@loginworks.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2017-12-21 08:02:10.982208	0	2017-12-21 08:02:10.982208	2017-12-21 08:02:10.982208	\N	\N	\N	2017-12-21 08:02:10.982208	2017-12-21 08:02:10.982208	\N	0	\N	2017-12-21 08:02:10.982208	2017-12-21 08:02:10.982208	2017-12-21 11:56:11.378661	0	Vikas	Dhama	t	2017-12-21	2027-12-21	5a3ca375632b6fc5g9vVWjD7K2QZpfp3FI5NkHE2KuZ	2017-12-22 15:17:25		12345678910	DL-102030	151415415	2018-04-25	1			\N	\N	2	\N
22	deepak	deepak.tripathi@loginworks.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2018-01-08 10:37:57.315128	0	2018-01-08 10:37:57.315128	2018-01-08 10:37:57.315128	\N	\N	\N	2018-01-08 10:37:57.315128	2018-01-08 10:37:57.315128	\N	0	\N	2018-01-08 10:37:57.315128	2018-01-08 10:37:57.315128	2018-01-08 10:37:57.315128	0	Deepak	Tripathi	t	2018-07-31	2029-07-31	\N	\N		1234567890	1234567890		2018-01-31T09:35:00.000Z	35			\N	\N	1	f
10	shekhar	shekhar@loginworks.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2017-12-18 15:13:07.93714	0	2017-12-18 15:13:07.93714	2017-12-18 15:13:07.93714	\N	\N	\N	2017-12-18 15:13:07.93714	2017-12-18 15:13:07.93714	\N	0	\N	2017-12-18 15:13:07.93714	2017-12-18 15:13:07.93714	2017-12-18 15:13:07.93714	0	Chandra	Shekhar	t	2017-12-18	2027-12-18	\N	\N		1234567890	123456		2017-12-31	1			\N	\N	1	\N
24	milly	milyrob5@ops.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2018-01-09 10:41:09.24712	0	2018-01-09 10:41:09.24712	2018-01-09 10:41:09.24712	\N	\N	\N	2018-01-09 10:41:09.24712	2018-01-09 10:41:09.24712	\N	0	\N	2018-01-09 10:41:09.24712	2018-01-09 10:41:09.24712	2018-01-09 10:41:09.24712	0	Milly	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f
19		vinay.kumar@loginworks.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2017-12-21 12:16:21.325487	0	2017-12-21 12:16:21.325487	2017-12-21 12:16:21.325487	\N	\N	\N	2017-12-21 12:16:21.325487	2017-12-21 12:16:21.325487	\N	0	\N	2017-12-21 12:16:21.325487	2017-12-21 12:16:21.325487	2017-12-21 12:16:21.325487	0	Vinay	Kumar	t	2017-12-21	2027-12-21	5a3cb427d9647iffFSe5K35b5zjDQJKb1H2z5SWmB5v	2017-12-22 16:28:39		457485415484	1245784512457845		2017-12-31	1			\N	\N	1	\N
20		abc@gmail.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2017-12-21 12:18:59.176052	0	2017-12-21 12:18:59.176052	2017-12-21 12:18:59.176052	\N	\N	\N	2017-12-21 12:18:59.176052	2017-12-21 12:18:59.176052	\N	0	\N	2017-12-21 12:18:59.176052	2017-12-21 12:18:59.176052	2018-01-02 12:59:58.419772	0	Aaron	Gibson	t	2017-12-21	2027-12-21	\N	\N		1233444445555	123456789		2017-12-26	1			\N	\N	1	\N
4	Matt	matthew.beard@o-p-s.net	e10adc3949ba59abbe56e057f20f883e	\N	\N	2017-12-18 12:34:26.949103	0	2017-12-18 12:34:26.949103	2017-12-18 12:34:26.949103	\N	\N	\N	2017-12-18 12:34:26.949103	2017-12-18 12:34:26.949103	\N	0	\N	2017-12-18 12:34:26.949103	2017-12-18 12:34:26.949103	2017-12-19 08:26:25.339452	0	Matthew	Beard	t	\N	\N	5a5c3ceedd968gIuJErQ5up7wOAdwLB6K9nM5ErK0hf	2018-01-15 14:32:30		1234567890000001	123-123-4321	1234567890	2017-12-19T12:26:00.000Z	\N	\N	\N	\N	\N	1	t
21		shashank@loginworks.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2018-01-04 11:13:25.825583	0	2018-01-04 11:13:25.825583	2018-01-04 11:13:25.825583	\N	\N	\N	2018-01-04 11:13:25.825583	2018-01-04 11:13:25.825583	\N	0	\N	2018-01-04 11:13:25.825583	2018-01-04 11:13:25.825583	2018-01-08 10:30:10.685495	0	Shashank	Trivedi	t	2018-01-04	2028-01-04	\N	\N		1234567890	1234567890	1234567890	2018-01-31	35			\N	\N	1	f
8	nishant	nishant.garg@loginworks.com	8015b90e6c44823ff6424dbb62c4da26	\N	\N	2017-12-18 14:18:39.710381	0	2017-12-18 14:18:39.710381	2017-12-18 14:18:39.710381	\N	\N	\N	2017-12-18 14:18:39.710381	2017-12-18 14:18:39.710381	\N	3	\N	2017-12-18 14:18:39.710381	2017-12-18 14:18:39.710381	2017-12-18 14:20:09.568524	0	Nishant	Garg	f	2017-12-31	2017-12-31	5a56f162cf7d51HDhd6AEw2iUy51jh2X5plq67JoieU	2018-01-11 14:08:50		1233444445555	1222-333-555	1233444445555	2018-05-31	1			\N	\N	1	t
23		nishant.garg1@loginworks.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2018-01-08 12:58:35.759115	0	2018-01-08 12:58:35.759115	2018-01-08 12:58:35.759115	\N	\N	\N	2018-01-08 12:58:35.759115	2018-01-08 12:58:35.759115	\N	0	\N	2018-01-08 12:58:35.759115	2018-01-08 12:58:35.759115	2018-01-08 12:58:35.759115	0	Nishant	Verma	t	2018-01-08	2028-01-08	\N	\N		1234567891	1234-2232-1235-3454		2018-01-24	44			\N	\N	2	f
29	Dheeraj	dj@loginworks.com	6f0d23b69092ffd9fed74e3fc55b84d7	\N	\N	2018-01-11 07:16:09.649576	0	2018-01-11 07:16:09.649576	2018-01-11 07:16:09.649576	\N	\N	\N	2018-01-11 07:16:09.649576	2018-01-11 07:16:09.649576	\N	0	\N	2018-01-11 07:16:09.649576	2018-01-11 07:16:09.649576	2018-01-11 07:16:09.649576	0	Dheeraj	Juneja	t	2018-01-11	2028-01-11	\N	\N		9990843868	342423423423		2018-01-15T06:13:00.000Z	2			\N	\N	2	f
25		christylin3@ops.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2018-01-09 10:51:06.55617	0	2018-01-09 10:51:06.55617	2018-01-09 10:51:06.55617	\N	\N	\N	2018-01-09 10:51:06.55617	2018-01-09 10:51:06.55617	\N	0	\N	2018-01-09 10:51:06.55617	2018-01-09 10:51:06.55617	2018-01-09 10:51:06.55617	0	Christy	Lincoln	t	2018-01-09	2028-01-09	\N	\N		+917838043535	555-555-555-555		2019-02-28	47			\N	\N	1	f
27		freddoug6@loginworks.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2018-01-11 06:21:13.992154	0	2018-01-11 06:21:13.992154	2018-01-11 06:21:13.992154	\N	\N	\N	2018-01-11 06:21:13.992154	2018-01-11 06:21:13.992154	\N	0	\N	2018-01-11 06:21:13.992154	2018-01-11 06:21:13.992154	2018-01-11 06:24:25.51472	0	Fred	Douglas	t	2018-01-11	2028-01-11	\N	\N		9953071294	5555-5555-5555-5555		2021-05-31	56			\N	\N	1	f
7	hassan	hassan.ali@loginworks.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2017-12-18 14:00:14.281191	0	2017-12-18 14:00:14.281191	2017-12-18 14:00:14.281191	\N	\N	\N	2017-12-18 14:00:14.281191	2017-12-18 14:00:14.281191	\N	0	\N	2017-12-18 14:00:14.281191	2017-12-18 14:00:14.281191	2018-01-12 07:05:26.010824	0	Hassan	Ali	t	2017-12-18	2017-12-18	5a5c3fcee91c89973UYcNQe3GE8qMNASa9TM7KBVgR3	2018-01-15 14:44:46		1233444445555	222-888-777	1233444445555	2019-08-20T00:00:00.000Z	1			\N	\N	1	t
5	lee	lee.beauchamp@o-p-s.net	e10adc3949ba59abbe56e057f20f883e	\N	\N	2017-12-18 13:48:38.14334	0	2017-12-18 13:48:38.14334	2017-12-18 13:48:38.14334	\N	\N	\N	2017-12-18 13:48:38.14334	2017-12-18 13:48:38.14334	\N	0	\N	2017-12-18 13:48:38.14334	2017-12-18 13:48:38.14334	2017-12-18 13:48:38.14334	0	Lee	McTester	t	2017-12-19	2017-12-19	\N	2018-01-15 14:41:56		1233444445555	1122-321-877	1233444445555	2018-04-30T12:45:00.000Z	1			\N	\N	1	f
32	sandy@gmail.com	sandy@gmail.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2018-01-12 07:56:27.68465	0	2018-01-12 07:56:27.68465	2018-01-12 07:56:27.68465	\N	\N	\N	2018-01-12 07:56:27.68465	2018-01-12 07:56:27.68465	\N	0	\N	2018-01-12 07:56:27.68465	2018-01-12 07:56:27.68465	2018-01-12 07:56:27.68465	0	Sandeep	Kumar	t	2018-01-12	2028-01-12	5a585c526afcf8XSvAs2Cu2uMR4L56OddKcq0DwLsrN	2018-01-12 15:57:22		7854854896125	55555-5555-5555	85684265495	2018-01-31T06:54:00.000Z	56			\N	\N	1	t
31	walter	walter.brown@loginworks.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2018-01-12 06:29:59.138142	0	2018-01-12 06:29:59.138142	2018-01-12 06:29:59.138142	\N	\N	\N	2018-01-12 06:29:59.138142	2018-01-12 06:29:59.138142	\N	0	\N	2018-01-12 06:29:59.138142	2018-01-12 06:29:59.138142	2018-01-12 07:46:14.5156	0	Walter	Brown	t	2018-01-12	2028-01-12	5a585f406edbdMw2QZ1T1GInEYwZ1J04672PN8nbLdc	2018-01-12 16:09:52	Den	1233444445555	999-765-4322	1233444445555	2018-01-31T05:26:00.000Z	56			\N	\N	2	t
33	asdf@gmail.com	asdf@gmail.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2018-01-12 08:11:01.118129	0	2018-01-12 08:11:01.118129	2018-01-12 08:11:01.118129	\N	\N	\N	2018-01-12 08:11:01.118129	2018-01-12 08:11:01.118129	\N	0	\N	2018-01-12 08:11:01.118129	2018-01-12 08:11:01.118129	2018-01-12 08:11:01.118129	0	sadasdasd	asdasdasd	t	2018-01-12	2028-01-12	\N	\N	sadasdasd	ascasasxasxasx	66666-99999-88888	asxasxasxasxasx	2018-01-30T07:09:00.000Z	56			\N	\N	2	f
34	ritz@gmail.com	ritz@gmail.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2018-01-12 08:13:23.633111	0	2018-01-12 08:13:23.633111	2018-01-12 08:13:23.633111	\N	\N	\N	2018-01-12 08:13:23.633111	2018-01-12 08:13:23.633111	\N	0	\N	2018-01-12 08:13:23.633111	2018-01-12 08:13:23.633111	2018-01-12 08:13:23.633111	0	Ritz	Noyace	t	2018-01-12	2028-01-12	\N	\N		456123789456123	5555-7777-3333	7894561235478954	2018-01-30T07:11:00.000Z	56			\N	\N	1	f
11	vijay	vijay.kumar@loginworks.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2017-12-18 15:32:26.256529	0	2017-12-18 15:32:26.256529	2017-12-18 15:32:26.256529	\N	\N	\N	2017-12-18 15:32:26.256529	2017-12-18 15:32:26.256529	\N	0	\N	2017-12-18 15:32:26.256529	2017-12-18 15:32:26.256529	2017-12-18 15:32:26.256529	0	Vijay	Kumar	t	2017-12-18	2027-12-18	5a58549cc30ebsJ4Cx4ngovB92Cn8XLYi33wCvwsE44	2018-01-12 15:24:28		7838043535	DL-101020		2017-12-20	1			\N	\N	1	t
35	vicky@gmail.com	vicky@gmail.com	e10adc3949ba59abbe56e057f20f883e	\N	\N	2018-01-12 08:15:05.6951	0	2018-01-12 08:15:05.6951	2018-01-12 08:15:05.6951	\N	\N	\N	2018-01-12 08:15:05.6951	2018-01-12 08:15:05.6951	\N	0	\N	2018-01-12 08:15:05.6951	2018-01-12 08:15:05.6951	2018-01-12 08:15:05.6951	0	Vicky	Brown	t	2018-01-12	2028-01-12	\N	\N		451545445544	6666-1111-4444-7		2018-01-29T07:13:00.000Z	56			\N	\N	1	f
\.


--
-- TOC entry 2748 (class 0 OID 16738)
-- Dependencies: 227
-- Data for Name: user_address; Type: TABLE DATA; Schema: public; Owner: -
--

COPY user_address (id, user_id, address_id) FROM stdin;
2	4	50
3	5	51
4	6	52
5	7	53
6	8	54
7	11	55
8	12	56
9	13	57
10	14	58
11	15	59
12	16	60
13	17	61
14	18	62
15	19	63
16	20	64
17	21	95
18	22	96
19	23	99
20	25	102
21	27	114
22	28	115
23	29	116
24	30	117
25	31	118
26	32	119
27	33	120
28	34	121
29	35	122
\.


--
-- TOC entry 2807 (class 0 OID 0)
-- Dependencies: 204
-- Name: user_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('user_address_id_seq', 29, true);


--
-- TOC entry 2749 (class 0 OID 16742)
-- Dependencies: 228
-- Data for Name: user_distribution_roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY user_distribution_roles (id, user_id, db_system_id, roles_id, created_at, updated_at) FROM stdin;
155	4	1	1	2017-12-18 12:35:38.214348	2017-12-18 12:35:38.214348
156	4	1	2	2017-12-18 12:35:45.901869	2017-12-18 12:35:45.901869
160	4	1	4	2017-12-18 12:36:06.401779	2017-12-18 12:36:06.401779
157	4	1	3	2017-12-18 12:35:53.72996	2017-12-18 12:35:53.72996
222	7	35	1	2018-01-04 09:31:50.1107	2018-01-04 09:31:50.1107
223	7	36	1	2018-01-04 09:33:06.58007	2018-01-04 09:33:06.58007
226	7	39	1	2018-01-04 09:40:05.640756	2018-01-04 09:40:05.640756
227	7	40	1	2018-01-04 10:06:41.437885	2018-01-04 10:06:41.437885
228	7	41	1	2018-01-04 10:10:14.82254	2018-01-04 10:10:14.82254
230	7	43	1	2018-01-04 10:26:27.706812	2018-01-04 10:26:27.706812
238	21	35	1	2018-01-08 10:30:10.685495	2018-01-08 10:30:10.685495
239	21	35	2	2018-01-08 10:30:10.701122	2018-01-08 10:30:10.701122
240	21	35	3	2018-01-08 10:30:10.701122	2018-01-08 10:30:10.701122
241	21	35	4	2018-01-08 10:30:10.701122	2018-01-08 10:30:10.701122
242	22	35	1	2018-01-08 10:37:57.346323	2018-01-08 10:37:57.346323
243	22	35	2	2018-01-08 10:37:57.346323	2018-01-08 10:37:57.346323
244	22	35	3	2018-01-08 10:37:57.346323	2018-01-08 10:37:57.346323
245	22	35	4	2018-01-08 10:37:57.346323	2018-01-08 10:37:57.346323
246	7	44	1	2018-01-08 11:30:48.827049	2018-01-08 11:30:48.827049
247	7	45	1	2018-01-08 12:55:15.73624	2018-01-08 12:55:15.73624
224	7	37	1	2018-01-04 09:35:42.617795	2018-01-04 09:35:42.617795
225	7	38	1	2018-01-04 09:38:44.881373	2018-01-04 09:38:44.881373
229	7	42	1	2018-01-04 10:18:29.436446	2018-01-04 10:18:29.436446
249	7	46	1	2018-01-09 10:01:33.540439	2018-01-09 10:01:33.540439
250	7	47	1	2018-01-09 10:03:44.025695	2018-01-09 10:03:44.025695
252	7	55	1	2018-01-09 14:14:21.521313	2018-01-09 14:14:21.521313
161	4	2	4	2017-12-18 13:48:38.315179	2017-12-18 13:48:38.315179
162	4	2	3	2017-12-18 13:48:38.315179	2017-12-18 13:48:38.315179
163	4	2	1	2017-12-18 13:48:38.315179	2017-12-18 13:48:38.315179
164	4	2	2	2017-12-18 13:48:38.315179	2017-12-18 13:48:38.315179
253	7	56	1	2018-01-10 15:16:21.62782	2018-01-10 15:16:21.62782
254	4	57	1	2018-01-10 19:08:35.439151	2018-01-10 19:08:35.439151
255	4	58	1	2018-01-10 19:13:54.852472	2018-01-10 19:13:54.852472
257	27	56	2	2018-01-11 06:24:25.54597	2018-01-11 06:24:25.54597
258	27	56	3	2018-01-11 06:24:25.54597	2018-01-11 06:24:25.54597
261	29	2	2	2018-01-11 07:16:09.665144	2018-01-11 07:16:09.665144
262	29	2	3	2018-01-11 07:16:09.680773	2018-01-11 07:16:09.680773
263	29	2	4	2018-01-11 07:16:09.680773	2018-01-11 07:16:09.680773
264	30	2	1	2018-01-11 07:54:47.582958	2018-01-11 07:54:47.582958
265	30	2	2	2018-01-11 07:54:47.582958	2018-01-11 07:54:47.582958
266	30	2	3	2018-01-11 07:54:47.582958	2018-01-11 07:54:47.582958
248	11	2	2	2018-01-08 12:58:35.774688	2018-01-08 12:58:35.774688
251	11	2	1	2018-01-09 10:51:06.587375	2018-01-09 10:51:06.587375
260	11	1	4	2018-01-11 07:16:09.665144	2018-01-11 07:16:09.665144
267	31	56	1	2018-01-12 06:29:59.153755	2018-01-12 06:29:59.153755
268	31	56	2	2018-01-12 06:29:59.153755	2018-01-12 06:29:59.153755
269	31	56	3	2018-01-12 06:29:59.153755	2018-01-12 06:29:59.153755
270	31	56	4	2018-01-12 06:29:59.169387	2018-01-12 06:29:59.169387
271	5	1	1	2018-01-12 07:56:27.715846	2018-01-12 07:56:27.715846
272	5	1	2	2018-01-12 08:11:01.133746	2018-01-12 08:11:01.133746
273	5	1	3	2018-01-12 08:13:23.648726	2018-01-12 08:13:23.648726
274	5	1	4	2018-01-12 08:15:05.710773	2018-01-12 08:15:05.710773
\.


--
-- TOC entry 2808 (class 0 OID 0)
-- Dependencies: 205
-- Name: user_distribution_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('user_distribution_roles_id_seq', 274, true);


--
-- TOC entry 2809 (class 0 OID 0)
-- Dependencies: 206
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('user_id_seq', 35, true);


--
-- TOC entry 2448 (class 2606 OID 16750)
-- Name: address addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY address
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- TOC entry 2451 (class 2606 OID 16752)
-- Name: alert alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY alert
    ADD CONSTRAINT alerts_pkey PRIMARY KEY (id);


--
-- TOC entry 2454 (class 2606 OID 16754)
-- Name: billing_address billing_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY billing_address
    ADD CONSTRAINT billing_address_pkey PRIMARY KEY (id);


--
-- TOC entry 2527 (class 2606 OID 17093)
-- Name: boarding_additional_info_location boarding_additional_info_location_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY boarding_additional_info_location
    ADD CONSTRAINT boarding_additional_info_location_id PRIMARY KEY (id);


--
-- TOC entry 2457 (class 2606 OID 16756)
-- Name: containers comtainers_id_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY containers
    ADD CONSTRAINT comtainers_id_pkey PRIMARY KEY (id);


--
-- TOC entry 2461 (class 2606 OID 16758)
-- Name: contaminants contaminants_id_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contaminants
    ADD CONSTRAINT contaminants_id_pkey PRIMARY KEY (id);


--
-- TOC entry 2463 (class 2606 OID 16760)
-- Name: coordinate coordinates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY coordinate
    ADD CONSTRAINT coordinates_pkey PRIMARY KEY (id);


--
-- TOC entry 2535 (class 2606 OID 17214)
-- Name: distribution_additional_monitering distribution_additional_monitering_id_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY distribution_additional_monitering
    ADD CONSTRAINT distribution_additional_monitering_id_pkey PRIMARY KEY (id);


--
-- TOC entry 2522 (class 2606 OID 16948)
-- Name: distribution_billing_address distribution_billing_address_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY distribution_billing_address
    ADD CONSTRAINT distribution_billing_address_id PRIMARY KEY (id);


--
-- TOC entry 2465 (class 2606 OID 16762)
-- Name: distribution_id_details distribution_id_details_id_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY distribution_id_details
    ADD CONSTRAINT distribution_id_details_id_pkey PRIMARY KEY (id);


--
-- TOC entry 2470 (class 2606 OID 16764)
-- Name: distribution_system distribution_system_id_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY distribution_system
    ADD CONSTRAINT distribution_system_id_pkey PRIMARY KEY (id);


--
-- TOC entry 2538 (class 2606 OID 17389)
-- Name: emergency_type emergency_type_id_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY emergency_type
    ADD CONSTRAINT emergency_type_id_pkey PRIMARY KEY (id);


--
-- TOC entry 2530 (class 2606 OID 17128)
-- Name: employees_recieve_report employees_recieve_report_id_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employees_recieve_report
    ADD CONSTRAINT employees_recieve_report_id_pkey PRIMARY KEY (id);


--
-- TOC entry 2472 (class 2606 OID 16766)
-- Name: lience lience_id_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lience
    ADD CONSTRAINT lience_id_pkey PRIMARY KEY (id);


--
-- TOC entry 2520 (class 2606 OID 16768)
-- Name: user_distribution_roles nextval('user_distribution_roles_id_seq'::regclass); Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_distribution_roles
    ADD CONSTRAINT "nextval('user_distribution_roles_id_seq'::regclass)" PRIMARY KEY (id);


--
-- TOC entry 2475 (class 2606 OID 16770)
-- Name: plant_address plant_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY plant_address
    ADD CONSTRAINT plant_address_pkey PRIMARY KEY (id);


--
-- TOC entry 2479 (class 2606 OID 16772)
-- Name: report_schedule report_schedule_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY report_schedule
    ADD CONSTRAINT report_schedule_id PRIMARY KEY (id);


--
-- TOC entry 2542 (class 2606 OID 17466)
-- Name: reports reports_id_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_id_pkey PRIMARY KEY (id);


--
-- TOC entry 2484 (class 2606 OID 17323)
-- Name: request_container request_container_id_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY request_container
    ADD CONSTRAINT request_container_id_pkey PRIMARY KEY (id);


--
-- TOC entry 2525 (class 2606 OID 16982)
-- Name: role role_id_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_id_pkey PRIMARY KEY (id);


--
-- TOC entry 2487 (class 2606 OID 17175)
-- Name: sample_site_images sample_site_images_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sample_site_images
    ADD CONSTRAINT sample_site_images_id PRIMARY KEY (id);


--
-- TOC entry 2490 (class 2606 OID 16778)
-- Name: sample_sites_address sample_sites_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sample_sites_address
    ADD CONSTRAINT sample_sites_address_pkey PRIMARY KEY (id);


--
-- TOC entry 2493 (class 2606 OID 16780)
-- Name: sample_sites_notes sample_sites_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sample_sites_notes
    ADD CONSTRAINT sample_sites_notes_pkey PRIMARY KEY (id);


--
-- TOC entry 2496 (class 2606 OID 16782)
-- Name: sample_sites_owner sample_sites_owner_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sample_sites_owner
    ADD CONSTRAINT sample_sites_owner_pkey PRIMARY KEY (id);


--
-- TOC entry 2502 (class 2606 OID 16784)
-- Name: samples samples_id_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY samples
    ADD CONSTRAINT samples_id_pkey PRIMARY KEY (id);


--
-- TOC entry 2504 (class 2606 OID 16786)
-- Name: status status_id_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY status
    ADD CONSTRAINT status_id_pkey PRIMARY KEY (id);


--
-- TOC entry 2511 (class 2606 OID 16788)
-- Name: task task_id_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY task
    ADD CONSTRAINT task_id_pkey PRIMARY KEY (id);


--
-- TOC entry 2515 (class 2606 OID 16790)
-- Name: user_address user_address_id_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_address
    ADD CONSTRAINT user_address_id_pkey PRIMARY KEY (id);


--
-- TOC entry 2446 (class 2606 OID 16792)
-- Name: user users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 2505 (class 1259 OID 16793)
-- Name: fki_address_id_fkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_address_id_fkey ON task USING btree (address_id);


--
-- TOC entry 2497 (class 1259 OID 17589)
-- Name: fki_address_id_fkey1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_address_id_fkey1 ON samples USING btree (address_id);


--
-- TOC entry 2480 (class 1259 OID 17355)
-- Name: fki_address_id_fkey2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_address_id_fkey2 ON request_container USING btree (address_id);


--
-- TOC entry 2485 (class 1259 OID 17186)
-- Name: fki_address_id_fkeys; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_address_id_fkeys ON sample_site_images USING btree (address_id);


--
-- TOC entry 2466 (class 1259 OID 16794)
-- Name: fki_address_id_fkys; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_address_id_fkys ON distribution_id_details USING btree (address_id);


--
-- TOC entry 2512 (class 1259 OID 16795)
-- Name: fki_address_ids_fkeys; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_address_ids_fkeys ON user_address USING btree (address_id);


--
-- TOC entry 2452 (class 1259 OID 16796)
-- Name: fki_alter_recipient_id_fk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_alter_recipient_id_fk ON alert USING btree (recipient_id);


--
-- TOC entry 2528 (class 1259 OID 17104)
-- Name: fki_boarding_additional_info_location_fkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_boarding_additional_info_location_fkey ON boarding_additional_info_location USING btree (distribution_id);


--
-- TOC entry 2498 (class 1259 OID 17687)
-- Name: fki_container_id_fkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_container_id_fkey ON samples USING btree (container_id);


--
-- TOC entry 2516 (class 1259 OID 16797)
-- Name: fki_db_system_id_fkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_db_system_id_fkey ON user_distribution_roles USING btree (db_system_id);


--
-- TOC entry 2488 (class 1259 OID 16798)
-- Name: fki_distribution_id_fkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_distribution_id_fkey ON sample_sites_address USING btree (distribution_id);


--
-- TOC entry 2523 (class 1259 OID 16964)
-- Name: fki_distribution_id_fkey2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_distribution_id_fkey2 ON distribution_billing_address USING btree (distribution_id);


--
-- TOC entry 2536 (class 1259 OID 17220)
-- Name: fki_distribution_id_fkey3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_distribution_id_fkey3 ON distribution_additional_monitering USING btree (distribution_id);


--
-- TOC entry 2481 (class 1259 OID 17344)
-- Name: fki_distribution_id_fkey5; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_distribution_id_fkey5 ON request_container USING btree (distribution_id);


--
-- TOC entry 2467 (class 1259 OID 16799)
-- Name: fki_distribution_id_fkeys; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_distribution_id_fkeys ON distribution_id_details USING btree (distribution_id);


--
-- TOC entry 2458 (class 1259 OID 17542)
-- Name: fki_distribution_id_fkeys2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_distribution_id_fkeys2 ON containers USING btree (distribution_id);


--
-- TOC entry 2531 (class 1259 OID 17664)
-- Name: fki_distribution_id_fkeys4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_distribution_id_fkeys4 ON employees_recieve_report USING btree (distribution_id);


--
-- TOC entry 2506 (class 1259 OID 17729)
-- Name: fki_distribution_id_fkeys6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_distribution_id_fkeys6 ON task USING btree (distribution_id);


--
-- TOC entry 2476 (class 1259 OID 16800)
-- Name: fki_distribution_id_fky; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_distribution_id_fky ON report_schedule USING btree (distribution_id);


--
-- TOC entry 2507 (class 1259 OID 17398)
-- Name: fki_emergency_type_id_fkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_emergency_type_id_fkey ON task USING btree (emergency_type);


--
-- TOC entry 2532 (class 1259 OID 17637)
-- Name: fki_report_schedule_id_fkeys; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_report_schedule_id_fkeys ON employees_recieve_report USING btree (report_schedule_id);


--
-- TOC entry 2517 (class 1259 OID 17710)
-- Name: fki_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_role_id ON user_distribution_roles USING btree (roles_id);


--
-- TOC entry 2491 (class 1259 OID 16801)
-- Name: fki_sample_sites_address_fkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_sample_sites_address_fkey ON sample_sites_notes USING btree (sample_sites_address_id);


--
-- TOC entry 2494 (class 1259 OID 16802)
-- Name: fki_sample_sites_address_id_fkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_sample_sites_address_id_fkey ON sample_sites_owner USING btree (sample_sites_address_id);


--
-- TOC entry 2508 (class 1259 OID 16803)
-- Name: fki_sampler_id_fkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_sampler_id_fkey ON task USING btree (user_id);


--
-- TOC entry 2482 (class 1259 OID 17366)
-- Name: fki_sampler_id_fkey1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_sampler_id_fkey1 ON request_container USING btree (sampler_id);


--
-- TOC entry 2509 (class 1259 OID 17595)
-- Name: fki_status_id_fkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_status_id_fkey ON task USING btree (status);


--
-- TOC entry 2459 (class 1259 OID 17606)
-- Name: fki_status_id_fkey1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_status_id_fkey1 ON containers USING btree (status);


--
-- TOC entry 2499 (class 1259 OID 17693)
-- Name: fki_task_id_fkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_task_id_fkey ON samples USING btree (task_id);


--
-- TOC entry 2539 (class 1259 OID 17681)
-- Name: fki_user_id_createdby; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_user_id_createdby ON reports USING btree (created_by);


--
-- TOC entry 2518 (class 1259 OID 16804)
-- Name: fki_user_id_fkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_user_id_fkey ON user_distribution_roles USING btree (user_id);


--
-- TOC entry 2533 (class 1259 OID 17648)
-- Name: fki_user_id_fkey3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_user_id_fkey3 ON employees_recieve_report USING btree (user_id);


--
-- TOC entry 2468 (class 1259 OID 16805)
-- Name: fki_user_id_fkeys; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_user_id_fkeys ON distribution_id_details USING btree (user_id);


--
-- TOC entry 2500 (class 1259 OID 17553)
-- Name: fki_user_id_fkeys1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_user_id_fkeys1 ON samples USING btree (user_id);


--
-- TOC entry 2513 (class 1259 OID 17704)
-- Name: fki_user_id_fkeys3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_user_id_fkeys3 ON user_address USING btree (user_id);


--
-- TOC entry 2540 (class 1259 OID 17675)
-- Name: fki_user_id_fkeys5; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_user_id_fkeys5 ON reports USING btree (user_id);


--
-- TOC entry 2477 (class 1259 OID 17483)
-- Name: fki_user_id_pkey; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_user_id_pkey ON report_schedule USING btree (user_id);


--
-- TOC entry 2449 (class 1259 OID 16806)
-- Name: index_addresses_on_coordinate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_addresses_on_coordinate_id ON address USING btree (coordinate_id);


--
-- TOC entry 2455 (class 1259 OID 16807)
-- Name: index_billing_address_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_billing_address_on_user_id ON billing_address USING btree (user_id);


--
-- TOC entry 2473 (class 1259 OID 16808)
-- Name: index_plantaddress_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_plantaddress_on_user_id ON plant_address USING btree (user_id);


--
-- TOC entry 2546 (class 2606 OID 16815)
-- Name: address address_coordinate_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_coordinate_id_fk FOREIGN KEY (coordinate_id) REFERENCES coordinate(id);


--
-- TOC entry 2569 (class 2606 OID 16820)
-- Name: task address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY task
    ADD CONSTRAINT address_id_fkey FOREIGN KEY (address_id) REFERENCES sample_sites_address(id);


--
-- TOC entry 2566 (class 2606 OID 17584)
-- Name: samples address_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY samples
    ADD CONSTRAINT address_id_fkey1 FOREIGN KEY (address_id) REFERENCES address(id);


--
-- TOC entry 2559 (class 2606 OID 17350)
-- Name: request_container address_id_fkey2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY request_container
    ADD CONSTRAINT address_id_fkey2 FOREIGN KEY (address_id) REFERENCES sample_sites_address(id);


--
-- TOC entry 2561 (class 2606 OID 17181)
-- Name: sample_site_images address_id_fkeys; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sample_site_images
    ADD CONSTRAINT address_id_fkeys FOREIGN KEY (address_id) REFERENCES sample_sites_address(id);


--
-- TOC entry 2552 (class 2606 OID 16825)
-- Name: distribution_id_details address_id_fkys; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY distribution_id_details
    ADD CONSTRAINT address_id_fkys FOREIGN KEY (address_id) REFERENCES address(id);


--
-- TOC entry 2575 (class 2606 OID 16830)
-- Name: user_address address_ids_fkeys; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_address
    ADD CONSTRAINT address_ids_fkeys FOREIGN KEY (address_id) REFERENCES address(id);


--
-- TOC entry 2547 (class 2606 OID 16835)
-- Name: alert alter_recipient_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY alert
    ADD CONSTRAINT alter_recipient_id_fk FOREIGN KEY (recipient_id) REFERENCES "user"(id);


--
-- TOC entry 2581 (class 2606 OID 17094)
-- Name: boarding_additional_info_location boarding_additional_info_location_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY boarding_additional_info_location
    ADD CONSTRAINT boarding_additional_info_location_fkey FOREIGN KEY (distribution_id) REFERENCES distribution_system(id);


--
-- TOC entry 2567 (class 2606 OID 17682)
-- Name: samples container_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY samples
    ADD CONSTRAINT container_id_fkey FOREIGN KEY (container_id) REFERENCES containers(id);


--
-- TOC entry 2548 (class 2606 OID 16840)
-- Name: billing_address coordinate_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY billing_address
    ADD CONSTRAINT coordinate_id FOREIGN KEY (coordinate_id) REFERENCES coordinate(id) ON DELETE CASCADE;


--
-- TOC entry 2577 (class 2606 OID 16845)
-- Name: user_distribution_roles db_system_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_distribution_roles
    ADD CONSTRAINT db_system_id_fkey FOREIGN KEY (db_system_id) REFERENCES distribution_system(id);


--
-- TOC entry 2562 (class 2606 OID 17069)
-- Name: sample_sites_address distribution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sample_sites_address
    ADD CONSTRAINT distribution_id_fkey FOREIGN KEY (distribution_id) REFERENCES distribution_system(id);


--
-- TOC entry 2582 (class 2606 OID 17099)
-- Name: boarding_additional_info_location distribution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY boarding_additional_info_location
    ADD CONSTRAINT distribution_id_fkey FOREIGN KEY (distribution_id) REFERENCES distribution_system(id);


--
-- TOC entry 2580 (class 2606 OID 16959)
-- Name: distribution_billing_address distribution_id_fkey2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY distribution_billing_address
    ADD CONSTRAINT distribution_id_fkey2 FOREIGN KEY (distribution_id) REFERENCES distribution_system(id);


--
-- TOC entry 2586 (class 2606 OID 17215)
-- Name: distribution_additional_monitering distribution_id_fkey3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY distribution_additional_monitering
    ADD CONSTRAINT distribution_id_fkey3 FOREIGN KEY (distribution_id) REFERENCES distribution_system(id);


--
-- TOC entry 2558 (class 2606 OID 17339)
-- Name: request_container distribution_id_fkey5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY request_container
    ADD CONSTRAINT distribution_id_fkey5 FOREIGN KEY (distribution_id) REFERENCES distribution_system(id);


--
-- TOC entry 2553 (class 2606 OID 16855)
-- Name: distribution_id_details distribution_id_fkeys; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY distribution_id_details
    ADD CONSTRAINT distribution_id_fkeys FOREIGN KEY (distribution_id) REFERENCES distribution_system(id);


--
-- TOC entry 2550 (class 2606 OID 17537)
-- Name: containers distribution_id_fkeys2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY containers
    ADD CONSTRAINT distribution_id_fkeys2 FOREIGN KEY (distribution_id) REFERENCES distribution_system(id);


--
-- TOC entry 2585 (class 2606 OID 17659)
-- Name: employees_recieve_report distribution_id_fkeys4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employees_recieve_report
    ADD CONSTRAINT distribution_id_fkeys4 FOREIGN KEY (distribution_id) REFERENCES distribution_system(id);


--
-- TOC entry 2574 (class 2606 OID 17724)
-- Name: task distribution_id_fkeys6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY task
    ADD CONSTRAINT distribution_id_fkeys6 FOREIGN KEY (distribution_id) REFERENCES distribution_system(id);


--
-- TOC entry 2556 (class 2606 OID 16860)
-- Name: report_schedule distribution_id_fky; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY report_schedule
    ADD CONSTRAINT distribution_id_fky FOREIGN KEY (distribution_id) REFERENCES distribution_system(id);


--
-- TOC entry 2543 (class 2606 OID 16865)
-- Name: user distribution_system_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT distribution_system_id FOREIGN KEY (distribution_system_id) REFERENCES distribution_system(id);


--
-- TOC entry 2544 (class 2606 OID 16870)
-- Name: user distribution_system_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT distribution_system_id_fkey FOREIGN KEY (distribution_system_id) REFERENCES distribution_system(id);


--
-- TOC entry 2572 (class 2606 OID 17393)
-- Name: task emergency_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY task
    ADD CONSTRAINT emergency_type_id_fkey FOREIGN KEY (emergency_type) REFERENCES emergency_type(id);


--
-- TOC entry 2545 (class 2606 OID 16875)
-- Name: user license_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT license_id_fkey FOREIGN KEY (license_id) REFERENCES lience(id);


--
-- TOC entry 2570 (class 2606 OID 16880)
-- Name: task nextval('task_id_seq'::regclass); Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY task
    ADD CONSTRAINT "nextval('task_id_seq'::regclass)" FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- TOC entry 2555 (class 2606 OID 16885)
-- Name: plant_address plant_address_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY plant_address
    ADD CONSTRAINT plant_address_user_id_fk FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- TOC entry 2549 (class 2606 OID 16890)
-- Name: billing_address public_billing_address_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY billing_address
    ADD CONSTRAINT public_billing_address_user_id_fk FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- TOC entry 2583 (class 2606 OID 17632)
-- Name: employees_recieve_report report_schedule_id_fkeys; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employees_recieve_report
    ADD CONSTRAINT report_schedule_id_fkeys FOREIGN KEY (report_schedule_id) REFERENCES report_schedule(id);


--
-- TOC entry 2579 (class 2606 OID 17705)
-- Name: user_distribution_roles role_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_distribution_roles
    ADD CONSTRAINT role_id FOREIGN KEY (roles_id) REFERENCES role(id);


--
-- TOC entry 2563 (class 2606 OID 16905)
-- Name: sample_sites_notes sample_sites_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sample_sites_notes
    ADD CONSTRAINT sample_sites_address_id_fkey FOREIGN KEY (sample_sites_address_id) REFERENCES sample_sites_address(id);


--
-- TOC entry 2564 (class 2606 OID 16910)
-- Name: sample_sites_owner sample_sites_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sample_sites_owner
    ADD CONSTRAINT sample_sites_address_id_fkey FOREIGN KEY (sample_sites_address_id) REFERENCES sample_sites_address(id);


--
-- TOC entry 2571 (class 2606 OID 16915)
-- Name: task sampler_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY task
    ADD CONSTRAINT sampler_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- TOC entry 2560 (class 2606 OID 17361)
-- Name: request_container sampler_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY request_container
    ADD CONSTRAINT sampler_id_fkey1 FOREIGN KEY (sampler_id) REFERENCES "user"(id);


--
-- TOC entry 2573 (class 2606 OID 17590)
-- Name: task status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY task
    ADD CONSTRAINT status_id_fkey FOREIGN KEY (status) REFERENCES status(id);


--
-- TOC entry 2551 (class 2606 OID 17601)
-- Name: containers status_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY containers
    ADD CONSTRAINT status_id_fkey1 FOREIGN KEY (status) REFERENCES status(id);


--
-- TOC entry 2568 (class 2606 OID 17688)
-- Name: samples task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY samples
    ADD CONSTRAINT task_id_fkey FOREIGN KEY (task_id) REFERENCES task(id);


--
-- TOC entry 2588 (class 2606 OID 17711)
-- Name: reports user_id_createdby_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT user_id_createdby_fkey FOREIGN KEY (created_by) REFERENCES "user"(id);


--
-- TOC entry 2578 (class 2606 OID 16920)
-- Name: user_distribution_roles user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_distribution_roles
    ADD CONSTRAINT user_id_fkey FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- TOC entry 2584 (class 2606 OID 17643)
-- Name: employees_recieve_report user_id_fkey3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employees_recieve_report
    ADD CONSTRAINT user_id_fkey3 FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- TOC entry 2554 (class 2606 OID 16925)
-- Name: distribution_id_details user_id_fkeys; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY distribution_id_details
    ADD CONSTRAINT user_id_fkeys FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- TOC entry 2565 (class 2606 OID 17548)
-- Name: samples user_id_fkeys1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY samples
    ADD CONSTRAINT user_id_fkeys1 FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- TOC entry 2576 (class 2606 OID 17699)
-- Name: user_address user_id_fkeys3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_address
    ADD CONSTRAINT user_id_fkeys3 FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- TOC entry 2587 (class 2606 OID 17670)
-- Name: reports user_id_fkeys5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT user_id_fkeys5 FOREIGN KEY (user_id) REFERENCES "user"(id);


--
-- TOC entry 2557 (class 2606 OID 17478)
-- Name: report_schedule user_id_pkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY report_schedule
    ADD CONSTRAINT user_id_pkey FOREIGN KEY (user_id) REFERENCES "user"(id);


-- Completed on 2018-01-15 09:27:40

--
-- PostgreSQL database dump complete
--

