PGDMP         0                |            school    15.3    15.3 .    U           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            V           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            W           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            X           1262    16554    school    DATABASE        CREATE DATABASE school WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Arabic_Saudi Arabia.1256';
    DROP DATABASE school;
                postgres    false            Y           0    0    school    DATABASE PROPERTIES     N   ALTER DATABASE school SET default_text_search_config TO 'pg_catalog.english';
                     postgres    false                        3079    16555 	   uuid-ossp 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    DROP EXTENSION "uuid-ossp";
                   false            Z           0    0    EXTENSION "uuid-ossp"    COMMENT     W   COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
                        false    2            �            1255    16859    school_code()    FUNCTION     �  CREATE FUNCTION public.school_code() RETURNS text
    LANGUAGE plpgsql
    AS $$
  DECLARE
    random_code TEXT;
  BEGIN
    -- Generate a random code and check for uniqueness
    LOOP
      random_code := CONCAT(LEFT(MD5(RANDOM()::text), 3), '-', LEFT(MD5(RANDOM()::text), 3), '-', LEFT(MD5(RANDOM()::text), 3));
      -- Check if the generated code is unique in your table
      EXIT WHEN NOT EXISTS (SELECT 1 FROM schools WHERE code = random_code);
    END LOOP;
    RETURN random_code;
  END;
$$;
 $   DROP FUNCTION public.school_code();
       public          postgres    false            �            1255    16775    user_code()    FUNCTION     �  CREATE FUNCTION public.user_code() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  random_code TEXT;
BEGIN
  -- Generate a random code and check for uniqueness
  LOOP
    random_code := CONCAT(LEFT(MD5(RANDOM()::text), 3), '-', LEFT(MD5(RANDOM()::text), 3), '-', LEFT(MD5(RANDOM()::text), 3));
    
    -- Check if the generated code is unique in your table
    EXIT WHEN NOT EXISTS (SELECT 1 FROM users WHERE code = random_code);
  END LOOP;
  
  RETURN random_code;
END;
$$;
 "   DROP FUNCTION public.user_code();
       public          postgres    false            �            1259    16979    courses    TABLE     +  CREATE TABLE public.courses (
    uid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    teacher character varying(255) NOT NULL,
    price numeric(10,2) NOT NULL,
    school character varying(11),
    created_at timestamp with time zone DEFAULT now()
);
    DROP TABLE public.courses;
       public         heap    postgres    false    2            �            1259    17251    lessons    TABLE     �   CREATE TABLE public.lessons (
    uid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    school character varying(11),
    course uuid,
    presents uuid[],
    absents uuid[],
    created_at timestamp with time zone DEFAULT now()
);
    DROP TABLE public.lessons;
       public         heap    postgres    false    2            �            1259    17139    payments    TABLE     �  CREATE TABLE public.payments (
    uid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    school character varying(11),
    user_code character varying(11),
    user_name character varying(255) NOT NULL,
    student uuid,
    course uuid,
    price numeric NOT NULL,
    quantity integer NOT NULL,
    total numeric NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);
    DROP TABLE public.payments;
       public         heap    postgres    false    2            �            1259    16961    schools    TABLE     H  CREATE TABLE public.schools (
    code character varying(11) DEFAULT public.school_code() NOT NULL,
    name character varying(250),
    email character varying(250),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    license_end timestamp without time zone DEFAULT (now() + '30 days'::interval) NOT NULL
);
    DROP TABLE public.schools;
       public         heap    postgres    false    234            �            1259    16992    students    TABLE     M  CREATE TABLE public.students (
    uid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    birthday character varying(10) NOT NULL,
    email character varying(255),
    phone character varying(20),
    school character varying(11),
    created_at timestamp with time zone DEFAULT now()
);
    DROP TABLE public.students;
       public         heap    postgres    false    2            �            1259    17470 
   timetables    TABLE     �  CREATE TABLE public.timetables (
    uid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    school_code character varying(11),
    course_uid uuid,
    day character varying(255),
    week character varying(255),
    date character varying(255),
    start_at time without time zone NOT NULL,
    end_at time without time zone NOT NULL,
    type character varying(255) DEFAULT 'default'::character varying
);
    DROP TABLE public.timetables;
       public         heap    postgres    false    2            �            1259    16950    users    TABLE       CREATE TABLE public.users (
    code character varying(11) DEFAULT public.user_code() NOT NULL,
    email character varying(250) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    providerdata jsonb DEFAULT '{}'::jsonb,
    provider character varying(20) NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false    233            �            1259    17451    users_schools    TABLE     6  CREATE TABLE public.users_schools (
    user_code character varying(11) NOT NULL,
    school_code character varying(11) NOT NULL,
    rules jsonb DEFAULT '{}'::jsonb,
    type character varying(250) NOT NULL,
    status character varying(250) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);
 !   DROP TABLE public.users_schools;
       public         heap    postgres    false            M          0    16979    courses 
   TABLE DATA           P   COPY public.courses (uid, name, teacher, price, school, created_at) FROM stdin;
    public          postgres    false    217   ?       P          0    17251    lessons 
   TABLE DATA           U   COPY public.lessons (uid, school, course, presents, absents, created_at) FROM stdin;
    public          postgres    false    220   E       O          0    17139    payments 
   TABLE DATA           z   COPY public.payments (uid, school, user_code, user_name, student, course, price, quantity, total, created_at) FROM stdin;
    public          postgres    false    219   pI       L          0    16961    schools 
   TABLE DATA           M   COPY public.schools (code, name, email, created_at, license_end) FROM stdin;
    public          postgres    false    216   �R       N          0    16992    students 
   TABLE DATA           Y   COPY public.students (uid, name, birthday, email, phone, school, created_at) FROM stdin;
    public          postgres    false    218   �`       R          0    17470 
   timetables 
   TABLE DATA           k   COPY public.timetables (uid, school_code, course_uid, day, week, date, start_at, end_at, type) FROM stdin;
    public          postgres    false    222   �       K          0    16950    users 
   TABLE DATA           P   COPY public.users (code, email, created_at, providerdata, provider) FROM stdin;
    public          postgres    false    215   ��       Q          0    17451    users_schools 
   TABLE DATA           `   COPY public.users_schools (user_code, school_code, rules, type, status, created_at) FROM stdin;
    public          postgres    false    221   �       �           2606    16986    courses courses_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (uid);
 >   ALTER TABLE ONLY public.courses DROP CONSTRAINT courses_pkey;
       public            postgres    false    217            �           2606    17259    lessons lessons_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (uid);
 >   ALTER TABLE ONLY public.lessons DROP CONSTRAINT lessons_pkey;
       public            postgres    false    220            �           2606    17147    payments payments_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (uid);
 @   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_pkey;
       public            postgres    false    219            �           2606    16970    schools schools_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.schools
    ADD CONSTRAINT schools_pkey PRIMARY KEY (code);
 >   ALTER TABLE ONLY public.schools DROP CONSTRAINT schools_pkey;
       public            postgres    false    216            �           2606    16999    students students_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (uid);
 @   ALTER TABLE ONLY public.students DROP CONSTRAINT students_pkey;
       public            postgres    false    218            �           2606    17478    timetables timetables_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.timetables
    ADD CONSTRAINT timetables_pkey PRIMARY KEY (uid);
 D   ALTER TABLE ONLY public.timetables DROP CONSTRAINT timetables_pkey;
       public            postgres    false    222            �           2606    16960    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public            postgres    false    215            �           2606    16958    users users_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (code);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    215            �           2606    17459     users_schools users_schools_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.users_schools
    ADD CONSTRAINT users_schools_pkey PRIMARY KEY (user_code, school_code);
 J   ALTER TABLE ONLY public.users_schools DROP CONSTRAINT users_schools_pkey;
       public            postgres    false    221    221            �           2606    16987    courses courses_school_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_school_fkey FOREIGN KEY (school) REFERENCES public.schools(code) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.courses DROP CONSTRAINT courses_school_fkey;
       public          postgres    false    217    3236    216            �           2606    17265    lessons lessons_course_fkey    FK CONSTRAINT     |   ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_course_fkey FOREIGN KEY (course) REFERENCES public.courses(uid);
 E   ALTER TABLE ONLY public.lessons DROP CONSTRAINT lessons_course_fkey;
       public          postgres    false    3238    217    220            �           2606    17260    lessons lessons_school_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_school_fkey FOREIGN KEY (school) REFERENCES public.schools(code);
 E   ALTER TABLE ONLY public.lessons DROP CONSTRAINT lessons_school_fkey;
       public          postgres    false    216    220    3236            �           2606    17163    payments payments_course_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_course_fkey FOREIGN KEY (course) REFERENCES public.courses(uid);
 G   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_course_fkey;
       public          postgres    false    3238    219    217            �           2606    17148    payments payments_school_fkey    FK CONSTRAINT        ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_school_fkey FOREIGN KEY (school) REFERENCES public.schools(code);
 G   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_school_fkey;
       public          postgres    false    219    3236    216            �           2606    17158    payments payments_student_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_student_fkey FOREIGN KEY (student) REFERENCES public.students(uid);
 H   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_student_fkey;
       public          postgres    false    3240    219    218            �           2606    17153     payments payments_user_code_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_user_code_fkey FOREIGN KEY (user_code) REFERENCES public.users(code);
 J   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_user_code_fkey;
       public          postgres    false    215    219    3234            �           2606    17000    students students_school_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_school_fkey FOREIGN KEY (school) REFERENCES public.schools(code) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.students DROP CONSTRAINT students_school_fkey;
       public          postgres    false    216    218    3236            �           2606    17484 %   timetables timetables_course_uid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.timetables
    ADD CONSTRAINT timetables_course_uid_fkey FOREIGN KEY (course_uid) REFERENCES public.courses(uid);
 O   ALTER TABLE ONLY public.timetables DROP CONSTRAINT timetables_course_uid_fkey;
       public          postgres    false    217    222    3238            �           2606    17479 &   timetables timetables_school_code_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.timetables
    ADD CONSTRAINT timetables_school_code_fkey FOREIGN KEY (school_code) REFERENCES public.schools(code) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.timetables DROP CONSTRAINT timetables_school_code_fkey;
       public          postgres    false    216    3236    222            �           2606    17465 ,   users_schools users_schools_school_code_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.users_schools
    ADD CONSTRAINT users_schools_school_code_fkey FOREIGN KEY (school_code) REFERENCES public.schools(code);
 V   ALTER TABLE ONLY public.users_schools DROP CONSTRAINT users_schools_school_code_fkey;
       public          postgres    false    221    3236    216            �           2606    17460 *   users_schools users_schools_user_code_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.users_schools
    ADD CONSTRAINT users_schools_user_code_fkey FOREIGN KEY (user_code) REFERENCES public.users(code);
 T   ALTER TABLE ONLY public.users_schools DROP CONSTRAINT users_schools_user_code_fkey;
       public          postgres    false    3234    215    221            M   �  x��Wۊ#�}��
��#�>���x<�	�0d~��>���Ze$uB�-`���0a2�&8�@�%�ɪRw;Cl����J��j���ګ��>���b��ƫl;+�iɕ�q�����_��uz��>��t���78���ox�]����ӷx�uq�;����������DC��/*x7h�V�WllWέ.q�)���Y�V�e�t�]Y��rOV����܊�zx>�|v{l�šlڮ������Hz�ae���9���c.�DaŨl�^���9d�$:�g֧�@�����/5��=~�0�Dv��8}}���W��۟b�Wگ8-)��t/���8�2���M'�r�ɈK=�0\�q�n�)��|��oW�ZnZ�ꏈUI ճy@4���Hfex��2͈�L�>D�Rb��2%���B�Z��A��/�o6����~+�\Z���֘4c�lK�]���)��Tֶ�Z���R�ë��a�9,�׻ø��HQ4�k�NI�U��SAS]J�����9�wÇ���~��np�B��A�&4U�(�mWٷ��Y�:�8�v������R�O��sh15��%��
k��t儼t��A��z/����=���7������u�F5��!q+���T���𢌻��m��7�v�<Bw�T1�&�Y-VE
UiC�s'�����氞q>��n��������Y��K�c	ʕT���Kë�]Y������O�n;�/�	�4�V���dӡ�`8T�>�
���K�n��� \���TY+�tP�M�`���=������d�����ɓ%���YN���Te�+G��X��5��>Y��D��:��r�9(��hJ*�^Uv����3����㬋_�u������蓍5��	c'@��&IrKɆ�J5��-v�L�ek��/zoC�����=�mTݢw��N���ms�[�����\���G�/����~�vV�쐣*��O�^��A��e��\�5-A�~R�	��=7���7���㻉��"E�������")t��H����\���L�c�A'0��
���[H<��ޔ�h��\�4x�
���W~:�o��X�1�]���PP�����dt�V,�p�LNӈ� 㥆�����;�yʑO)r����ح4-��6��#���0$a�)�Q����ݵ�x�?���i86�T��Uc`�'$CSJ%�rai����E�8m�jSƳz��U���5��,��f[����#N�}D/r�Ǣ�SF5fe�����lKE#��� �K�e�@�&f�Q�u�n�a&��5sJ��������kb��p�@ ��kP�H���R�}D��|^_g�]�T2�i}�SOȮ�_q׏1N �kj��"9�q�ԓ8���3����B]��L��^�91k�|�P�4�'Nb<!t>��0��^���/��KC��[�;p]X�_����>�F^G]@�hs(�J�2a�s� z�Cȟ=+տ�0�g0JKȅ�a���gϞ����      P   \  x���K�ID��S�~L!�d��&��h��%˞���MKP1>�.���+O�Y����^�[���苺:Cn�sh�B3d�
'���Z�N�˗�����G�K/3��a��+eF���f+6}��V*B��k{�|4�G���W�o��XF*�g4�L���6O�:>��פ}��:�w	�K]�psWʑ�4F�^��ʭW-�E�>2Z��\?�P��9Rz˓�}X���#=�YH�ު���:(��wW�f����i_B-/+��h�}<d��������jr:>U6�lcќj�L���9��*�{�G�G�;�D�U��*l��iٝ��i��\���|��Vu�5�6�Tϡ���K���#u����I�9�2�U�X-g��>�\�U�i�B�6�RNW����A+C.�xl�f����km�� }k���z�&&�>��rڳ���qY���s��Ӌ�c�r_{QP�$��}�UU� ���<���"*���R
K m�&L�c�s��7Y��M�}ߢb�/6���7\�Lrr�#ׇAb�r��G����#���x8�wꮿwf���Z�]�d+�9�Z1A�+hp,��hr8��:y0�Y�ԹV��_c�te%@)���
�<�����յ�R�L�vOnY�yT�A�x0�8M��#�������:���%���]���&r�į�i�	<�K�%��$>:�{S���f��N�F� ϙ8��l�ә�1r�CD�g�o� ��؂�B��L�� +^�g߮/-0_���܍#-��?���m�S�Ӷm��[]������(�����6�X��0�i�~��i`�84+�=�G{�Af �#�PR�=X��U}^�t\n�Ji$l�ѷ'�M���ٯw�&���T�úy*�2&~p�eEAJ#�w.�*)w`S3�0��9�IaH�Ԛ�R�E�Y*�V�*#g6ɭ݂��6��,P�4��I��ó/�_*U~�c}0�Ք�y��[;z5)��1 �#K ��D��E��HZ��O�
@��Rюo�x|iw@˟��wM��7@=�E���Y��<�|�I�Yq�!�Z5�3�Y���>#N.q%�W6�r<��������ެ2      O   ,	  x��Zˎ9<�_���f����7�'�O����3����<;�qk�mnBC�������d�¥Y��R󐓕PW�������4��:B-1��.yR�C,����O�����O�Ӓj�j^r�ܭ�4�D�e�%qo���������}�<]�(��I�G�:�]8r1ҏDW�k��R�l���!.�Q��MC�q��,�6G������ǭ^��W�#�|�3�lI��, �aK�q���k�s�Mߞ�{ȭY�1�1g��f��2WjB�B�.���įԛ�*������%ǿ��kL�L�p!�?��Y�e�>h	��K��ܧ�x�7U�/�e��`Ouß�uqa�C6�`Qs kf����O��E^�/t���=����٪+Pk��JP)�v)*���ǣ�����QJ"��=������UC&,D�C��[���xU��9:��Ї�����8���C�[�p�D�P�3��6B�Y)��m�M��?_H�B�q�n�+�#�Y��~�eIA�=����Zm�a�[��MR����<��B�:J��-H��E�e�]��||JGL9��t�˜2	��=��i�g��0�o��ﾅݱ\n}���5Y��5�_Z�)�::�m�^�|tN�-!� _y�Pm<cGJ�ҏ�\�b=I�|j~���*&;q0��5�g��*�z���	?�C�ƿ��h(D���_+��x��-[�b5�β^�M��7����*rH�O��B�1a�����P���!�3�6֫�����-mZ��QP�\�K��U�G��veW�C�b9���W�Wن�||d']cŦ��*�� Q}GÔQ�!�p\�{��L$�:x�-�D-|V�$�{�3��:��V��RCS���ҡ���1�{0�Dr�B��%_JLci�D��sYs�����H�Lz�?q����zy�t��rC�4>�η�l�=,]�W�T.i��Y�E;t�g(B�_�?}�t�_��"� ��h�z[�|j�Z�B�u1Tf-(ۜ��w\��CZ�s���	������-|�m��L��9�E���[E\����7���#�+��dvD��mGG<��᪈j��F�Btj=sB�OO���W�[�J6���@�c4���u���]��>���Z?��[���ߢ�k��%�x����'w�+FC�p�h�t�7�7��8�X���C<���D��"c�?�>����e���@��t�[� 6PG��&���v3e��u���u�k�rDE~<u'2E�Dз�Ev�C^�#�"H;���̟I�?��1�ܒfaL���	7���:⦩��d�퀺�D��ZU#l��UA�&��k�"��BO�H���:w�@����`D\����``J�D�O���������mv��ੰ؈���jM���o��W�?�z���\�Ҩ�ۣ��(9��e��t?��|����VA�L�4�g��5@2DƇkᮒ|B��ع� O��z�zn���!�FA��r2RU4Suf�����o]��|D���g�P̅�7���Rτ�OR��������8p�_�M�ϐ4�EW �T"��g�?�bÆ�B��|K���L��8\G��L�����V���4�̆��U��G۳��ƒV���zE�qK'wr�l�u�s����εj�6V�Z�u�A�K�3��$�Y��%C���Ԕ�B[y���_��5л��"3�ł����+�����m�����17��@������g���G���Zw�Fm:f�A����~�n��mo	<|>�9�mL�S;Y����cZP�F���9��&���OG��T��FBy2#�:w�J��2�4��|6�dg�^n[<�KL�y���>%p���&���_0����B���ܟ�gO��R�5�NT��ї����,F�V�ΰMܟ��e%Z����\Wto���T������>��$(>0�'z"Ρ�bX�R�0��h��Aq�0i	�ܻ�/o�9_b\P����(���/$8���F�c�z/�����i��6C����B����܃z�2�3=�%�	��{�G�}߮q�.9
�c�}�B�P���੔`�`"U�l�>���,�� >\�qE�Ԙ0n���7[�����:{���'�e�?F�ZW�S&�ٻH9]�V2�lZz�렎��0��aQ�(�]���<����s�Ա������UɹF�8�k�%�Ph�����]�/|o_�C��#�>�`h>���6he��[��7����AQ��#C=O�܅�Ӭmo�+��SP��T���<�~����a�#0���s|���Ky��      L   �  x��ZYo�8�~f�
a�f�+R�f.�'�tr�ƍ=��#���X�[��ί���*��4�ɀ�b�d�,�rX%NYī2f?����j�����(�mru����H*�\��g">EXđ�򰤸H.m�<�Th^U{�7Ԛ.8�vt���vj��m�mkv�����dv��a������F�9'�3��}q����OMc��ѤǮvC���5��E'P��(����=o\|�Lﶓ��ک�)t�����o��t�5���{�4�������aC2���Ʈ��4T*��T�gT��ԏ���Ť/j{�*Үv�º�m�*�o�==ؚi���*��,�DžR��68��ݲ�k���q޽�����ܖ{�#_��q㷭��6���]i�g������B�c{�nmM�;��fm[z�PU�B9�<S�Fu�Q���QپAqOM�NCH㡰��-�#Wτd/������؞t�l��麛�⚎M����2�6�M� ��/q�~{\���0v�&�e��	WV�MѢe��F^��鮽���U���i�TJ��/E�>Pk�P��]���u��dAܠ��*g�G� �d2w9L�g����[�)�{E�-�4��7.4�}�Y|B�x�!]��=9�^~��ص�K9X�!�!�9�P�֍����z,�ڐz=�KòrRY�mfqþд����������9++2�E9O�w74��W[��'wwx���,�\�Pb����#ȅ��;��oYLt��2�8ٜ}������3�]i��եu#�������iǝ�$�/�0�<:4�v�dNc��2UT�<�,���N��ޟ���=�ۭ]��F.2�K���/o�� �ދ�}C�$-���H��]K�൹���u�.�]�9|-�f�8��RP�{�{�nk(:F5d5�^l��,n\]�Ebxl V�b�����!�mo��u'�[��&�x�<�	�<�6xa[jd31��� ��Y7�u�],�z�\�	�� ��|�z�T�C^�֠.����b�Պ����Xi��vn�;K�u�v\;�g�8�UG	����-�W=]��=��e���g|��� Pͭ`^xZ)b؊�I��� ��%��2����g��@-�`��2ó�d�v��)xY���`�S���JBr�!]jO�/j�^9�-� t����
�J�̒�ۃ��Ђ�.Q�Дv�c}/�Tc�����1�.�_&�A�@j�>]���0�+z�&x:���̾;�` ���?&c��"[{�ڂ�$���iR�<�S8{�qƣͿ	�
Q�a"㡠��mʗ�n��,3`���3:>xK�4�FikUX�t
r3��^�5����"3#�r�������ˈe @�(����j8�k���t�V��Rs�è���f�gF��6�#�m<��<�أ�b�@J��+�po Apݾ�K_�n���	��Ȕ�@I�T�zȃ���2�3�/w��n�%�D���Six�)���m]�^L��Njmq_���g%{��b�ʫ�iu�aRdg%죭|A���<}�A�Ӱ��cU ēT���Χ�v�DK�������ɧ���w��R���_��!q����1~�0��pעZ��f�[Q�Ȇ�}��2;��8k��^:�����jG�?�AG�ę�=��'.���Ą���P�
��s��#���(z-.������,X�'���n?��=+Q&O+.������'���\�j�F�����u���Nx��\��}v�ݠK��n�j�~tu[Ջ�R=�	[A-9?M����eo��֌F��9�3{Ke��~��q���a��kM���-4M3_�ݵL[?�m\x(�5�]�ׅ�)�A#�wu����zjj׍�f=��L�^4�~����}뇮Ob�^�����R2X�cn��	�&~�ZD�29ǃ�Yvb���Mg��B{����9Ws����ӕ��q�ҽ�|��\Uj�	��P�;4��@�v�Hj�Vt[�b%U�}A�\"c�Q}S�ܬ-���d.��L���7�%�6�W��� �.<R���I��-/#	.��A� #�keS��b�'���
�	���]�\��n�#ͥ�)�O�啱���~���ƭL�Oe�Rs,,�p6_j�㠗�-:�B�׊(�5KT���eW��,�g~��b�0/T伄���Љ.�8oG�w����X��LSp���������/aAB���D�x�Y�+\���2}��~���N6���qt��t}�Dq�d��nGMC&x?e��Y�y���D�[�M��4fJ�BU�3d�q�;CīL�L�ʹ�z��I��Q8?��Cg|?=���Lƕ�콟��k[�#���<�Z�ve"�0/���(�"8׻k �7�{8�	Ƹ�3,�����o�7�7�=�<���9?;?Im.��\�۬������H��r��V�5'��(��ǟxt��64�[�j��h�X�<�M�m��4o�)k�P�{	t�ʽ��R@4J���1�|��ر��>(��⑭x^�L7�k��v�m�2t��#E��<�O��rӣ������밇�'x�T"�4�\���>A�z�=����y'����Lr]e�rX��z�
�ݛ�5�Aa_���^��V�q��a�LP��E��[�=���=��#37��S��4ĳ�*sU^��}�����d��ӄ΄��9�K�<�6��.�������[?��ڵ$�%zDO��U���=x��\_�,�[-#�Ĉ�:b?]�ٺ�z�h[K��t���Qk.-�_�:?�����ǚ'��TW<K��.���/*���L�3��w��́� R�7S߂WӅewU���Z򤂄������v0��lx�8���%?�4����+����t����!\�SU		��@����:�]]����.,���?����>�$9�*�b�ƏG����&G���3I2�q��3��Qr�T(�,K���åMæɂS�2�*]�-���'�љ���$�q�찔���F��/���>?� �R�)�da��$U���4�+����{~&�0˕����O�69�L�!͉a��`�?��>�q|�!쉈��ݿ_���O'����A��r�_h�~��_~������s����I %r��	3%����K�piC80��3�vAy��G�g*>2����#�/mr�Y#2W)�q��G�Ce�s�EgI�8����?X��%��,��RF��P����3Y�EQ��\&������bd���W���f��{�I�"��z����&�5Wb
�����Y��n�GY�p瓥Mo��*�['*��4M�﷾]��G��dɮM5<joy�B�����'Km���re �}Ʌ�H3U<��di#|�����#Í6�B��Q���>Y�T�9*y��y�օO� �ȇx��)
�T^$����{��*D��JN�6�*�_�{?rk%��y?��ӥ�=��<+���,� ��"�E*o���Ҧ���T{)���U���qW��0�i������Ϳ��f�f���      N      x��}˖G��:�+b?'p���J��%��:�>�1w7gb��H@թ��k �I�;"�,�L"<����kG
ђ�y"�����s�Ig۪W�F����z����~0J�I�I�a
����z������o�}��JG�/�/��d
��c�8�:�By*T�d�s11����s��:�<�Q&��t�~�_��z����A��\�!��v�2o|^�Ě2�>)Uyrݙ���)fn)qP��᯼e>i�7�O��Ö��ȫ�q��������������G�����d�l�uؗU��&-k�k��M�
6?�2�`~׋n�Đ�����ǯ�W޾�]���qxය�m��~}��v�Մ1f��}|R�:�VcRc�1�G+M�M�*=��#ŢR�u�r�������o����N�m���Wm��zZ	*�Ƥ�If�%Md�����.u����M�p�r�}�佱�Rom��w���q��n���=/�ͧu�V�Ҋ�tڕ-�]I!�1i��C�&������:�y5?�)�\���j�W��{ޏ?�,v����N>LV��hχ=�pV_��fwl+nG���z���f0U
S�na96k��ŏg�'�4M�Ï8�=��g�v�����d5/+�9���a�~�p��bw<lv�_N����h�h��:���Hea9�S�����Bu���28uf�
cwh�Y�����z�p
 ^�{:�ؚ{��s�:�Rcp�*=XW&�x�z�xbs%tD�^K�!�s<y_�	���fx[x3�y�~S���Y�f�~X�8)Y|3�<��'���E-�Mo��jS���l~����Y[��:���m`�?���و�:i7���w��)��i-1�l����X�EK[XKq�*��d]��8�?�#��s)� ���pH��������y%V��Q��V����~u�o�=s���L�}Q��[��St��(]|�6�OѦ�)Ն�[w��cD��x�W���%���U!h�<l�0���i�v�w�!k�ɨ��C�eڮ&Y�B(.�Y�8*W`ȵh���8�X���W0�踑�x���?<��W~8��qs�_Q����>���������`�@CCKQ�"ʸ�s�6�ɱ��D������8����w��ن¶�w8��Ֆ*������È�uc!���Y#L,�Cۜj�`!"�r+S���N����S��k����-���5����@�|Xu:V���Ő�;�����2�	��xp�S���rZ�O�Eegr���i�8~	P?�������=�ϯ���v�w�M��y,������%���%0�){�%T�Lj0*,�ȷ������ʏ'�N���$��s��{��lM�l�K`NBj`�.a��l�.DhU,��@���5o�Q۝NI	���Zb��@F4\KY;431K�K!9hӬ3f�qفUN) <v�k�Ɓ���o�����\�D_b�x������h<<7�K��K;Һ��o�a�bs!P ��уqo7��������z��h��¶`����t�����%Q@,fl�RT�� 5%Z�?�W%��
*�0|z܀��~�)�M�`� ��%Oz��[��L
j���-���&��X�@b����AD���K��@�����b-�h�=>\B��d�2&|$�5K��M�vӰ�	Q�Rpv��f���߸������p:DD|r�m߁����,�i�	�2�	�ji!�95hS�Q� LB��{-YHV��������<�2��Jv�=��q���au��؊������7�vYK[�l��^hx��HZ��v��R����mǿ�
���fF쇇��{������q��G �%�=�����\��� ��eA:1�FQl�HT^�y����<0|�pw$������W@�W��޽</�� ��@⨸%��Om�L\�F�%��5�6Pd�P6Ï���z<��Ӣ��t�)�|�1��<��~��,h0�xjP�D&����h]5|�G3 ~���C��3�Ik!x�/,>b3�aK�n� �g
��r2�!�
T/�<�p`PP����dA@ſ3���[�I����ww��%��qD����@T�Ċc�A� ��r��զVz���b�<�ぎ�7�u���ݙ,�',E����{�tat�;�hqT��](촓�C��NNÝH|��t���ևB���lx�N1�b��miuO~8R�gf#fJ�@��S�s[B "hK�tD&����*
(�� �%  ��ɥqP������>��zx�X�<�E��3�\��
� �JQ�]� |~��5 y���=��̦4�("�/Z�E�m	�^.�A�%^����#���d��S�H!��lStu�	@������^���5���#��)'񜊟�$�P��z�XΒB E(Ŋ�L0�!sl8�X,���L��??�����x���yH>6�y_ī�����������5v؎k�2��)���&f?��;��j=�S ��4A<q�� 0iI)��s$9Ժy��p,;)��p�M渞[�%��j��=޿���%�*a�π�G'��5:�T˱`jKf\TEe�`	��L`Q��͹��-_��9��b�v"�.,��Ʀ��Va�A;��ϖ��9���䦷f���3�Z?�|�z�p�aގ����.Ȗ�`*�-��w�}
3��!��B@VLvqS��]1P��X/��C�KD.t�{��.i��S�	�1sZ��<Z$I�	L��,D�iKJ����f��u�4��D�-qFh�2�￮�It��$��~�/�Ģ�Gp� �Ya~ݖ)�E~�r�0W�(~q�
�	xw�{ �
�A+n�����(٬aCU�F��I]��B6�6<�*:ƙ���B��] S��%@�z0hzKH�������9�'�$��ə����^C�� ��ۣsLP�R�e�@&�Uv��q�����E�93�sV�5l���^H��xc�e�DS�$�^:2�U��@��
+��Aʂ2����}��Y�?R]�9�yB��n{��|�f���lGg!�L��J�j�8�
�*�B�7M���I�-�Q=���dn�>��9)mE���x��O��:#ց��дD� :�O-v<gYM�.Z%���	;�ƚxs&�&�1��6���*ɒ#� �<4��%s����sw�7�U���l�����hDB�9�8����ü�S6&��#���I
V�-���;���!N�+��
��I%ی�q���|�mO)X�/�9S]��WRO�C��~"�Ø�_��K�;���P&ɱ8�C�熠ܨDE`�)�s��fwܴS�QD%����u;BV��_�2�	g�a�[QiՒEkfE����j�n�b%u�L������{��e:s�{L*���V��$�q��?z�7�`P����R$��RL����KR�)��f��?DV�p�s5�/��:>� w�sg%�� &�� Ӫـ杲gNR��u��4�BS<���{�a���I<�4ϭ;� h��Y�Ѳ^\�)J1�$Id}b��(!Hx���-݃�Ư�'t �	����� �p�D�~"��z;t-bE*�K�{�R-���u]2�3)��n�����ؕ���c;�z%���WR�<���7؎��X�8x�3��ZU�,&�",��ҦbT�����?do��������F�� Xw�*��UY.zl	�8��AB����̴�18�*�I�48-����t�O�K����Y��~����Gfn%��R�b(�/9�-�8'E+��2�N��ej.���c܇���7���v���p����a�
����B~^5<���z�!�T[�� H^��N�jP`(6���R-���=,�ѹ��jΑ?�*D>�`�Ʀ��1��br\����c�x~N@M;k��"��M�m�ǿ׿�������i���^�     YY8=<L�bX,_vkf�nL��uL��&EP4�_�nx�j�;?>%�a>М뎥�D��AH& 
e�zd��.�(�����*I��v�/%�(� j�`����0�@�J��<�{�6<��_&�.�$�&0'=����&�y��A5$�Ȗ ��dͱ��4��8|�?nw�_�ۓ
WB�L��'~���<��"�ܸX�@�u��z�r��#@�2���ȁ��?�v��FP��B+���������@���d��9D��h�BoDH_��v��k]MRv���]j�V%"~E�s^6�X)�/�Q��72�y���A��Y�Y
�)E���sJ��@-#�9hg�$N�������0�����E����^�0�m��pa�(���t�o'�MR��e�@�v'G��l0�C��M
����ψ�H��Yl�;QbM����3���`���H��'?$YS2�IN�p-�,�����]���kރC��dZ���ޯy�ZK��ul#f;�PD�$p�+��)`��[����SSWR�O�eR�R��^�� ��w����o�����87⼈�0�(� %�EXJ\,�)m�o�O�X��u
�	:'U"(�4G��^��>>'��I������)�0Dq���_jp!e ����	�:I�_A�
4|�k��ۀN��	�U�`V���K�.��N�n��N��_�E+�U�T�,��.	��v�N�TAW@�A��5~ �ٟo3\\,2P�.r�BUC@\6��z�i�uy)�S��%�h�:�\#5�������P�_�i�nD�<����0'��B�)���!Nk�C0C S������6b'���:��C��U	1/���]�o<�}���T�6��9���S�� X�t��~8�%�j�
��,y�h(/�oQ,�[0���������n{����n~��S���.h�1d�@�H�rW���z���Nj{�e.y�ɸf@�>�_*u>�^�֯�0�b�/
D)X�ek� �h�#U^:!O�����,�*�����Zҵ����s���<P����W�g$�c�͞�躊�� �,=�K��A���AB]�~�>l��攐<��a ����Y��=���E�UX�Ud�dh	�w�$c���p&�S%�U���$�������(w�&->����~]�U�w0���� �m)�Ec�+)5��s�c�uA��1@����+�[o	rI��l�)'��3���Xo��!7i-�S\��2�B�Rt�R�,RS�Nݫ�#���:|�ٌ���ć��f�I佨r�ј������Vm�dT�0(p�yYUi����Cr���6���W��wV~I$�yC��~O:���<�_�Go�A4)hֺ���iX{))d���|��_�d��AZ�??6����W�^��f����R ���)�-�K� X�oMM2�P'8D��lj.݇o��ڬOu�+��y�'�"m4��m@6j�贸�G`w��扃��L�7�[e�17�����vIw_�%�9e}r��3�yrb��8H�D�����Cm�cK�zX��4�nN��5?�=
b�Xʜ%cz�V�P8�|�)6��R� ��v
�i�iD�P�g��Y`�`A�B�$��w���O�|���MDJ^E��\;�^3�)��\�Z��'�Bd7����ES��_�<�/|n0C�Υ�:)]H (�؃d7w��/�T�=�G �R�@Ap��Qk67�Y]���X��w��>���^{�5��=���`��9<g(	?��+`��hcl;D���C�"�ܝ�l�W��~��pf'��Nz��I/�,�_d�h�J#|I�V��R�UT���H��a���+bw��dx�~�ތ?�v�H'���G��Rt�C�f�`m�7����|�4�CP��IP��L�Y�MA>��<n��{�m�\RU/! ���U��0-z�Pj �aɿ�$|��_:<"y6�j�K�s��~��d�6Hp=�<���D�![��+�:��-�
z��bDT-�W�HTE�4H�݁����'�=5n�g�DUn/i��<��ñ�.B��K�>0i/	�`�9ŧ� /`�K{���7R��?�MAM���K����E�<�������-��B�(~�
�T�8R&�1�c��J�0�o�b"T���N�w%:�W����w& ��0f��1��/vDt��B��tC���R-����~~=�p�c��s#;d>���.��i@㣞A��#�	�RS��c]�sA���6Y�zBx�Z^��eM	.�i�/��������so��|> ,�Wk��陼��Yl�iJt!��U�Ie�a����J����o�=>�߬} L�K�-bݥ��q8!$����C��J�9�a��s�K�e��J䬤��?!� �~��?%4�M���	���A�ܿ28nZI �h\�Q��=46�����>6�+�����Q�˩M�f�s����x�a�#jS��?�
��k})�"��ȵ�2Օ$=�#��%A�P+��'䢬)�c�}@o�	\k2�d�YN:qYy�n�����@�也�t �*�W�֭:E�k�?!��뀄��Ã=|�M	Jr�= 
���:!��	`ئ{�`��~_�L�*�lc���r���d��U�pNi"�+�5`���z��ܧ/����9�K�I��4��s��+L�}��,���m�Yj�2
�Yq�r�r���Vl*�����p�S�4�`�9��	�+�L�d,��Z0r� ��dys���Z=L��&�>}Q��$� ����D�`[�n���b9^A���3�tDI�1��q�'i��8!��K!xp��T�e`����r������<!���8��e�E�pF��T�р���
rW8<P25VR�zjZ�rO�[���\խrWx}Խ$��$�OU���L�!4r�	|˄���x!kd�B�6`%��L�&�-�7M�]~RIi!������Rn>�T>{BqL͂��]��*@+�b# ����'�>}=ܨU#� !7��
0w�R��.O��	�+XE��h�ۄ~�&����ᑽ��8~����Z��59H�3ʨi8�N�;�9�&�>}!�]
�27�$]d���$����mF��}B�
���ɩ���8��W �4���y�	�+b/��!�N|*�x{Z �� ��5~��ܧ����XՔ���d�=���r�)���'�����Z�Pe:����2E�F҆���}B�
��d�����T@�t[6�tn�'�Pr�&Z/62˃e`e��u�\̫L�]bTv�ti<�-hg�!5�P/�k���	�k�'T/� i����nJ!ꝼ��c�iB�
0Rdr�� ����T"�*Ŧ�[y�	�+��7�e��Qޑ:�p��q�v)W��>!��)�`�b�,HP�����Ek��GÄ���T��但sW��A2V#Q7N�}��������re�﹩S��Tt,7O�}�rbE�!+��H���T6��w�0	!�ϝ���R��2�-I�j��NEaQ���	�+�@t�,b���G ���v��*�~����c�ɭ�l��Q.��������9rW����	2�R2vBI�J*Ǒ��*�Jz�	�+�K�q�j��:r�Y�4%`xМ�[��	�+�ȹT�n;w��nʅ��JUՃ�@��<!w�*'��T��X�2[h����Zw�&�>}!��~��'��df1�Ct�z��+L�]�N]rSY��=+$��?�N�5¥B�qB�Ӄt� �� �&/���T!�p���.�҄�;�`S�CS`F�� ��x�0�b�=�8!w�_E]�4�(r��Z�ek�`�z���U&䮰蚔�K,}ƅ`���qX��ؚט��&>�&�N��y��5e6cMrqZS�7!w�%3�����YN�PhS,6��P���uB�
^���m�}�I�����H&q�yB�
���C���#t.�J&7w�#�8!w�j��b���fHh�))y�,���Ƅ�⒚���z�,w�yѻ@,`*����io���"�	�i;�Լ�+���( a   K=�.���W���"0묻j��qr����N����^Z�����Ǝ-W�K��*�P-��1kUD��9!w��K)���ʁ*H�K�:kV����}B�
�2N�2�5��BD:��m-B�_aB� ]����ԬT3�9)>�k(gaC�|Ƅ�5֓���Q�j`�xD��� �=���rר�a(u
�e��(�*�s'��'䮰ͦKlU�ɔ�{rO"C[2@�כ���~<��R�J��`�d,ƃ���^oBm�fq�'{5Vd�dV���3���L�]�W&�M�k�$y)��tj!�J���=!w��&�L7U�������pȵ �ڪ�9!w��f��0[!�6��n��K�}�	�+ܽ���r�y��6Ѝh�ąC���Xír�R=��w���W�L� ԋ�{�a�&䮨>��Ԏ�q2w�����OZI'D�Ϟ��bc��χ
�h�(j�K�"��+�5��U&䮰��Ͱ`�`,W扬tcEʚ���>{B�
�Sǚ��sQ��u3�G�md�gX�r�=��r|�Vj2@#}H0 Sx�'�i���]�B!I&�J.W�j*�ֹmB�ҋ�7�L�cg�,a*ҝE@I����	�+�dT�I)W�4�%�. �u���N�]a��axl|J��N��mj�j�P�ғۄܧ�P,�T�=�ܯ��4#c�v���O�]����7Xi*q�wJP�=�NźpÄ�51$S1r�P��/��/���k,�O��W"�8!wM�r.�g��Dj�-7צ(���_gB�����V�� 2pz�rI�&�l�dXքܧ�1U*NF͊|#�&�1wFēf��gN�]���e��H�i!p��P��$������	�+J�Y;�j�˝����^��b��1���>!wE���־�����@��<������~΄�5��&�JRQ���|q-!�S'����ϟ���&���
ⷌ����YУ"�3�O�]�W$�����%���&��F`��ט��Fjx?��s��C����$��2U�O��&�ʽ`��U��t�1K=;��\ ��	�+N����> ��8�/�l��7:��jrW,+�"�^O�$�K+i"�9�\)
2$�0!wMo)�|gIι����Z�*0)V˭rלdW��R�q2@�l�K*� ���>!wM�; ~�l�����^�!V%y���n���B/�>�\����z"��{m0h����L'�yQY�;@�h�7ʿ�y�rT��
�����om	�ϝ�p��t�&rt/�%��q`;���?��ݧ~U�Tp�L*�¹:�Nͽ��K2���T�\�*�˵��]��ߞ�P��(���	
���I�	�ɽ�$�Ҩ�<�W }{��@���g�%�֥:ha/�Qy�p��7�����Jo^~���M�zc�ʻ�©-�`U�ʥ�>��Zn#4�����7h�:5��$��a�؞l�#����<�yc��Wۣ��o&W���,Z�R�Vulp� ��.��������qPi�T�͑#���#�踎x�L7ҀWr������˹m�rN�KV��k�X�BD�ϯ�U�I�K�@���qKcܖ������0�nփ��HM�w�q~�c�*��^3�Lٲ�Fn�t�p�/���[���f������_����RoTX!X�t*ع 7�H��'��*�2V?��q<����%�ZA�i}��$�m��sX8+^aJ�܉�Et���-�c�;�x�so��S�<�&����"*Z�x��e��ē���n�����Af�MK��*�����5��Y�v���h�IM��� W \=h�#���b�*d��I��X�L��.7ғ|	��[R2W%_�)ߩ(���@��>Dv�/3��&Opp��
I�0;���S��i�ss�}�3�'د�q�:>H��9����J��.0}�x�Ƅ�����t��Wm�O_^'��|Kny�	<�������O_��3vH:������׫ �f�_�]����&�Lv���S.��y��|w����O[)OO�F�LY�$ۛ�i�Y9��?.XV�%T���F������O���Bab�Lȋ�7v>	�%�gc���?��O�v�y      R   �  x���]n#G���wa@�����K�>�1�jd�x�^Ȁ`�4_Y,v��K�Tw%�I��Tx�,#�z�6���ӡ�E|	Iç���O�\x��Ňz����rc����x3�n�����X�i3S�6�����F{�!{W[k^��itY��#�R2j:3��t�h+ �+���-_��%ɞ�4��ը��\�}	g<�|G-��jĉ��7Nw~�Iz�.{�X����5�μ(�f��df}]�O�z3���7?󭠾�ߋ,��CD���x��R4Vc�S�ڦ�����*��Q.�tb���>�%�����I@�U�bD.�^V�e��1��RױQ0������������������u�Jc%b���_�ί�����w���Q:ν����J�ڨi�Ƶ���&������)�U�VK��l��s��-��������hԗ��j�1C�J�$�_ם.|�c���f��Me9|?��^(��Q}���/���R)�B�+���Өh�T1K������wn�yiV�F����Z<Md�o����_�=�B�Eb.M��� Xp��\4څ�ttk�W�����;��e�����^w���-��Pt[0��F�@����_�ou?��s&��11�Lu����^�<�;�u�k�h�Q|+\��4��97LgY����]����G����P�)��]�6�z�K�S7�%��z����~B����q���j�]'ҭ�q�Ya�A���Jú�N9�q���_	IeM8���u'Ev����9��E�}!h�N<?�8���y0�5uZ��U�d�aSU��6go�{圯���k\�J��$Y���l����e��M��Z��wv�%�L���@[@_1S�������\�ĭ�3tْ�m��ݼq���7"�u��2��~�H�§��/���[z�Y��Z���S��q�C�G�a�7ͩ���`��V����������㏷��&#��      K   �  x���_o�0ş�SD�n�G��6���U��&��`�84	�f�wa�*(��i��t|}ν?_�0�A�VU�ԕ��m��:��<k EXX�x <�l��W�[_;z���Rr�S!q�d��VǄ�j
Fa�m�YX4�j��TfS��Q��_*��i��j]�EU�J��M�N�<IպTE��J����]���yo��,z˾D�{���|�4��O�ui&����/�0���oJ)P�d%z�����F��L�?/��٨B�ZͧOsU�Z}k�h�-"��D!��V���gY�NP&���kS*%�����%��$�����c�yh����5��rY�ۡ��LoL�r���h?t0�l��uP�b�I�ȸy�^@�na�a�Q�	�����L���b�w{��)��U�w��s�G�_��3��ps���(���>�Q�I�%R�߭��֏�O��1W�O̯X��H�H?��{�_�v��+�I      Q      x����n�8 ��F��!�����E����\Xr�b�w/� i#E�a�\2�N�Dr(| ���h�H���5`;������r�ʔ��+�t����R�:>��Υ�˯��06cWV�Oe���uE�|�e��P�lb��ܴw�F~�l���]���c����t7�����|.S��U�0o���C�e|^�S���o�C����Z�i����ːW}��W��0���}3�q9 ������(����y�Ԙ�z�]�K���Zڌi����ױ�M7_*)$�@�H�����Gm���������P��\o���U<�R\��K
G�1	�"4�.{Y{0��.��{|��Ӊ0٨�$�����-��|�O�틏��ɐ�VsK|=t�@�|�O�퍏u��� ��5��`"�.�=�'��݊1�MҤ�x��t!;I����}⣘�5�襽|��{bO���������2�V29ȅ�|�O��wР�H5��B���u����0P��˲�|�o��NL��C��o��ǚf|�O��O_�F����>����r�'��[೬�-�Ն��K���$����%��}�K|m���}+G��
7�@h
��M� �#b�\/\do�4�RYR�2/
>����x=�W�\��<�09@���|x|2/
�w��<��4Q���V�5��{Ё?<M�'���}���޾�/:(���|�o?|����!�Uޚ~H�B/�dQ*4�uQ���Ĭ��x�������
~x�     