CREATE TYPE APPLICATION_STATUS as ENUM ('new', 'assigned', 'on_hold', 'approved', 'canceled', 'declined');
CREATE TYPE ADVISOR_ROLE as ENUM ('associate', 'partner', 'senior');
CREATE TYPE PHONE_TYPE as ENUM ('home', 'work', 'mobile');

CREATE TABLE IF NOT EXISTS users
(
    id       bigint,
    email    varchar(255) not null,
    username varchar(255) not null,
    CONSTRAINT users_PK primary key (id),
    CONSTRAINT users_email_UQ unique (email),
    CONSTRAINT users_username_UQ unique (username)
);

CREATE TABLE IF NOT EXISTS advisors
(
    id   bigint,
    role ADVISOR_ROLE not null,
    CONSTRAINT advisors_PK primary key (id),
    CONSTRAINT advisors_users_FK foreign key (id) references users
);

CREATE TABLE IF NOT EXISTS applicants
(
    id                     bigint,
    first_name             varchar(255) not null,
    last_name              varchar(255) not null,
    social_security_number varchar(255) not null,
    CONSTRAINT applicants_PK primary key (id),
    CONSTRAINT applicants_users_FK foreign key (id) references users
);

CREATE TABLE IF NOT EXISTS phones
(
    id           bigint,
    number       varchar(255),
    phone_type   PHONE_TYPE not null,
    applicant_id bigint     not null,
    CONSTRAINT phones_PK primary key (id),
    CONSTRAINT phones_applicants_FK foreign key (applicant_id) references applicants
);

CREATE TABLE IF NOT EXISTS addresses
(
    id     bigint,
    city   varchar(255),
    street varchar(255),
    number varchar(255),
    zip    varchar(255),
    apt    varchar(255),
    CONSTRAINT addresses_PK primary key (id),
    CONSTRAINT addresses_applicants_FK foreign key (id) references applicants
);

CREATE TABLE IF NOT EXISTS applications
(
    id           bigint,
    money        int,
    status       APPLICATION_STATUS not null default 'new',
    created_at   timestamp          not null default now(),
    assigned_at  timestamp,
    advisor_id   bigint             not null,
    applicant_id bigint             not null,
    CONSTRAINT applications_PK primary key (id),
    CONSTRAINT applications_advisors_FK foreign key (advisor_id) references advisors,
    CONSTRAINT applications_applicants_FK foreign key (applicant_id) references applicants,
);