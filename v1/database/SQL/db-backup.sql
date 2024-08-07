PGDMP         
                {           school    15.3    15.3 '    F           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            G           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            H           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            I           1262    16554    school    DATABASE        CREATE DATABASE school WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Arabic_Saudi Arabia.1256';
    DROP DATABASE school;
                postgres    false            J           0    0    school    DATABASE PROPERTIES     N   ALTER DATABASE school SET default_text_search_config TO 'pg_catalog.english';
                     postgres    false                        3079    16555 	   uuid-ossp 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    DROP EXTENSION "uuid-ossp";
                   false            K           0    0    EXTENSION "uuid-ossp"    COMMENT     W   COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
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
    course_name character varying(255) NOT NULL,
    unitprice numeric NOT NULL,
    quantity integer NOT NULL,
    amount numeric NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);
    DROP TABLE public.payments;
       public         heap    postgres    false    2            �            1259    16961    schools    TABLE     0  CREATE TABLE public.schools (
    code character varying(11) DEFAULT public.school_code() NOT NULL,
    name character varying(250),
    email character varying(250),
    created_at timestamp with time zone DEFAULT now(),
    license_end timestamp with time zone DEFAULT (now() + '30 days'::interval)
);
    DROP TABLE public.schools;
       public         heap    postgres    false    233            �            1259    16992    students    TABLE     M  CREATE TABLE public.students (
    uid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    birthday character varying(10) NOT NULL,
    email character varying(255),
    phone character varying(20),
    school character varying(11),
    created_at timestamp with time zone DEFAULT now()
);
    DROP TABLE public.students;
       public         heap    postgres    false    2            �            1259    16950    users    TABLE     �   CREATE TABLE public.users (
    code character varying(11) DEFAULT public.user_code() NOT NULL,
    email character varying(250) NOT NULL,
    password text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);
    DROP TABLE public.users;
       public         heap    postgres    false    232            �            1259    16971    users_schools    TABLE       CREATE TABLE public.users_schools (
    user_code character varying(11) NOT NULL,
    school_code character varying(11) NOT NULL,
    role character varying(250) NOT NULL,
    status character varying(250) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);
 !   DROP TABLE public.users_schools;
       public         heap    postgres    false            @          0    16979    courses 
   TABLE DATA           P   COPY public.courses (uid, name, teacher, price, school, created_at) FROM stdin;
    public          postgres    false    218   �3       C          0    17251    lessons 
   TABLE DATA           U   COPY public.lessons (uid, school, course, presents, absents, created_at) FROM stdin;
    public          postgres    false    221   6       B          0    17139    payments 
   TABLE DATA           �   COPY public.payments (uid, school, user_code, user_name, student, course, course_name, unitprice, quantity, amount, created_at) FROM stdin;
    public          postgres    false    220   :       >          0    16961    schools 
   TABLE DATA           M   COPY public.schools (code, name, email, created_at, license_end) FROM stdin;
    public          postgres    false    216   dG       A          0    16992    students 
   TABLE DATA           Y   COPY public.students (uid, name, birthday, email, phone, school, created_at) FROM stdin;
    public          postgres    false    219   IH       =          0    16950    users 
   TABLE DATA           B   COPY public.users (code, email, password, created_at) FROM stdin;
    public          postgres    false    215   �Z       ?          0    16971    users_schools 
   TABLE DATA           Y   COPY public.users_schools (user_code, school_code, role, status, created_at) FROM stdin;
    public          postgres    false    217   4\       �           2606    16986    courses courses_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (uid);
 >   ALTER TABLE ONLY public.courses DROP CONSTRAINT courses_pkey;
       public            postgres    false    218            �           2606    17259    lessons lessons_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (uid);
 >   ALTER TABLE ONLY public.lessons DROP CONSTRAINT lessons_pkey;
       public            postgres    false    221            �           2606    17147    payments payments_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (uid);
 @   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_pkey;
       public            postgres    false    220            �           2606    16970    schools schools_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.schools
    ADD CONSTRAINT schools_pkey PRIMARY KEY (code);
 >   ALTER TABLE ONLY public.schools DROP CONSTRAINT schools_pkey;
       public            postgres    false    216            �           2606    16999    students students_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (uid);
 @   ALTER TABLE ONLY public.students DROP CONSTRAINT students_pkey;
       public            postgres    false    219            �           2606    16960    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public            postgres    false    215            �           2606    16958    users users_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (code);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    215            �           2606    16978     users_schools users_schools_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.users_schools
    ADD CONSTRAINT users_schools_pkey PRIMARY KEY (user_code, school_code);
 J   ALTER TABLE ONLY public.users_schools DROP CONSTRAINT users_schools_pkey;
       public            postgres    false    217    217            �           2606    16987    courses courses_school_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_school_fkey FOREIGN KEY (school) REFERENCES public.schools(code) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.courses DROP CONSTRAINT courses_school_fkey;
       public          postgres    false    218    3228    216            �           2606    17265    lessons lessons_course_fkey    FK CONSTRAINT     |   ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_course_fkey FOREIGN KEY (course) REFERENCES public.courses(uid);
 E   ALTER TABLE ONLY public.lessons DROP CONSTRAINT lessons_course_fkey;
       public          postgres    false    221    218    3232            �           2606    17260    lessons lessons_school_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_school_fkey FOREIGN KEY (school) REFERENCES public.schools(code);
 E   ALTER TABLE ONLY public.lessons DROP CONSTRAINT lessons_school_fkey;
       public          postgres    false    216    3228    221            �           2606    17163    payments payments_course_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_course_fkey FOREIGN KEY (course) REFERENCES public.courses(uid);
 G   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_course_fkey;
       public          postgres    false    3232    220    218            �           2606    17148    payments payments_school_fkey    FK CONSTRAINT        ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_school_fkey FOREIGN KEY (school) REFERENCES public.schools(code);
 G   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_school_fkey;
       public          postgres    false    220    216    3228            �           2606    17158    payments payments_student_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_student_fkey FOREIGN KEY (student) REFERENCES public.students(uid);
 H   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_student_fkey;
       public          postgres    false    219    3234    220            �           2606    17153     payments payments_user_code_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_user_code_fkey FOREIGN KEY (user_code) REFERENCES public.users(code);
 J   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_user_code_fkey;
       public          postgres    false    215    220    3226            �           2606    17000    students students_school_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_school_fkey FOREIGN KEY (school) REFERENCES public.schools(code) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.students DROP CONSTRAINT students_school_fkey;
       public          postgres    false    3228    216    219            @   T  x����jA���SlF��~_�"]\�M���aK'�Hj�_�va���u^��6	�TR{�����'�L�R2l+�o\���J}�r��jG��PG�Tg����&M�yC�+�TJ�����@���R������fF�o�^�`S#e!t�`Cw\�2�Zu�\q��8˻�l$Q����#ɋ/��>�Q�u��{-9��j�
�u�m��bU����������o�|���������v~8���ϒ�^�����y'�zm	-Rm`� 6[�u]�`�a������S��0J�뒇�l�T���7qt~���6|l���7�ݿiQ�0 &-MT:�#-uףs@�d�5$N
�ޫ�	u+E��|��+��v'r��V���ipzɁu����ώ {A�Q7�:x��Q�k��S.c��Q�<���l���؈u���Q�RDMЪ=b�-�*i�T�X��մ�-sr]�t"�C8v-&.���(D�bs:�ΛA)����j����IFm�7h+��#�:�����%�����Q�)w@Y�WfP*<�%����*9*5�(�m^K�����g]�竓Z��L����G����b���6!      C   �  x��VA�9<ϼb�k"ER�߲��>1ؿ/��Ir��f�5|h��X,�j�=z_T�W�>+X�5�F㗪BP��yu�3��;n��,������B������Ki|��]�v�Xy��jPt�Z�B�ϕ�[i��;i�*�h�i�{1�<Q%��ٱ���Py�ں�Y�����ⁱc)i��c-+Z�1gC��Y�jS���]C~zԖ�X�C�5�0��cBj	Ӗ���'~���z��ag߽@���2���:��{��]O\K��HS���N��7
��j���N���3�0�0�h�k�[K_j�6�w�3y`��d�ޣE�*V�6�ƹ��cY�sG�&�p\�$$us����|��7p(�E-9�>���Ax+����|{G��-W��=rB�T~A+�SllOZMS�5�Q'p��M��l^�t��	Z/�pQ�Ft��?7�Y��W���ѓU�F�AV����ްr�$A6վ�vj<Mx��n�[�3����&���+Y��,��'1��T�$}$|ߘ���s���
�4�?&�kҹ���g��=vsX-���Z	K����Cj�Ĭ{�ύ�?{�m� ���c?��;çvdr�6f� ���KLP�,�]�>c��V��^��ok�bw���sE|�fkC���}&�*���Zu�;'�/����*�A+��l�)�`���N�W��?����P� �gx0�C��ڹ9���|�+>��[�7��*m��V&'KNI \�uN'��a>a[v��N��	�U3νC�N�R%�ɳE(wó��T�y@&W���qm�5\�XuQ�Xi��3&�=���¦�F�A�i����)?��)�;�.蓗%s�*�>�sE[Y;/��%��t���"�e��`��,�2�I�T�E���4��<�&e�'��J|#|e�k^ygl>+�H�)tE�5Ϛ\�%i�f�IՌ�KB9����	qP����}�ӽ�qF��ﯯ��r9d�      B   B  x��Z���u��|�͍:��z�́BGN���"032H*�c�#��#��	�o����9��iJ.�{q���U��z��1e
���uʡPְ��T��Xn�y�A��q���������7o^�}���J�'���&��,�9,�:ӈ��t[�HSn���F[!�Q���}�%�[��w������?�W��>o��Nt���MH40)/�*����G�M_Y��k�d�ܩ����6񌗡�e�n�a.��L8<bk����h�������Wo~��/o���$�c$����d��l�\#������:~$)-�uH��1�BZbX���!��;Mo^�������˘/�R����0_��׎��(��]U�P�a�,{Vb	%O�A�1�X����`�G��a����S/�	s����7�A3�dm�G��b�5�d�����_����d�	?�T�R��1�ψ����}�2��pf�'�t��Z����7�C��čJ����w����������ǻ?ܢ���?���N�QZd\B�=��-�,u��DT;-�v����D�ݳQ�	nL��Cm�+OP�3#��Dͩ�eH�'|,=_�H�e��G�(�������o���˱=���w����o�������ݧ��!|w�I��!��h�PZ���ZD9��&zL=��ц����u{p��ܨe�����5L(��ꫀ��`X{!��@ޱ�*)��)�4'-#�X���O�/��	�{d��6Dm�����i��(���1#�ֽ�"�VP�y�RoX���(�\���%���4=$߳J��A�UK�w-�P
�zMlո�V΀�K.&!��~�BX�L���uq�% �G�s ��R<�o�7+][�Y�.�
��v�HMs�9�Z���i|��P�� �cC��z]1m�Ό�(�m����[ﻚ�Y�e����)YKR&T%�I��*̎��g�i�KJ�K0��s <���C:��^�{p⅍�F�bUR�ݜ�u�5\I5��\
�S���G�2]#���{�b~�T�ΔgC���`�"�B�-�ڈ���ؑ�O,r�&�I[G-�Ƴ%�>s����҃�6%��Ɛbd�J�,vB)(�<��̭_����3������3
��Z�}N���]�Z� J��+Ϫ�����$�)(���P��]Ø����[��w����o��6o�; �|�#]�Aȕ�a'*��7� �5���Ƞ�9h�Ś�U.[�ͥ�w��0a+��=ڄ�OFb�^�]O<t~5x��:׻ď����H.Nޤ V��e:R/�f
X��k�SY�Xv�O`	��b���ֻ�:G�Ɛ�ڨIkDMҶƝ�-��uo�v5��b+���d�Z�0,��/�{��ȱ7-%o6��RQX׭�(>��28���+n�X�M �kձ��l�5$~�u�Q�l� �Ȯa���V�Ftl�96B��֥+�5��a۰�a�m@i+Lo��J�d��B����=d�E�4�c+�!���F�i6>�`�<jۉ���H�pn�O��g'���i��g�!X��lI�UwK�t�lr:�pМc]�Q��k�<�J�>+�_�I
4��~P\$3\�5i��K(<џ2�&�S)�3�ڨ�� �\'��8w�3�R�B[A�t�n�0Y�,�Ij��|���r���9F��Aᡂ:��_ ����c�싒�g1���7a8*�@�c,_�i�zG�����ns���=٭��˺}[����W�������W�E�S=�C�Rᬞ��6��<p-�z�W�G��).U��u{;߼}����yc��}F�A;ڒ=�o��4'K2��N�#�$�e�4�-�����A.l�taأ�Z��+���͒ی�^jX%�iuM9g�NYE�6���nGu��i�Sanz��o曟4%i���n���4%�ژ�L���64�H�?J���))��a��Z�p��.��"׌Śð�>I���N�tA����Ցᅂ�7�q[h�S9�!Y�C�U���k�ԳF/ھ� ��`x��������>�*8J�!��%TD�ýC:h���J�|��bƚX�`܎+��hU����/��������1�u�mA��d���T�I���%��V�eu�"c�"���7��+a�9 &��ӌ�eL�[�5�G���ۻk^*�Դ����{��س7r�.���i[i`���� �{���e-~��၆�#����.m�R�/��d	Z$5<,H�Z�܉�)wu=��=Jt��-������<��s�o�ts�����C`*�9��$%�ó�C����.��MQɌ���L,v���xO.�"�7���ҁ�lC��m
�wz�YSP����%P1.�j'4QS����)E9�����a�K�^���$(/5C���ͪ�q��/�Ҝr�0|�A��|U���Y8.v��\�!�(���<g�	0��)\*j1�Dǹ*�s�^��B���U���Q��`ID���Ů���iZp�\�)�"_N��������<_����V:~��
�	m4�J�{ץ�X���g�!�x�5�~�B¢��� �G"��D��Pz��#'��i��Dcc�}����vg�b���e�����hX��]������f�A�[kp��0�HP�Sn�/T��u4��u2�a���)����b�޵�>?��s�=o��=�C�D��A�P�:����مh�_D���N�������:�q�g��Eۄ*J!�ǹ�956�LE4s[Ac\��\��ض^w���?�]X��|�*Rr.��#�l^Yc3�&m+��G=��1��1|B�O�{�M�=8d�#iA��e�&�n�E*`�&甥�`V�}\�
�Gs����ؙ�U��1��?���<�k�PIv��Sv�Jx
h��-X��u/�|	�O�����~O�|�>
�}֕�)����U��z5Q,�ܑ�_���e[`�.8���k%$pv<4��k�C�C��H���K[_	ç-�ۡ�d��BG%%d_�mc���+-{ڦ 4F:7T�J��3 ����Q'�ی����G,P���d0���aM^��F���K��9�I+��ӶA4����y9׭N�TC������m���S���н�`�C�s@d붻�̺/�xn�ux��� �A�_�E��s�r�VKX5����6�y��|jeȨ�p/;7E����v\{�>�@� E58��Ҡ;�Z�s�[ڧ}�@�I��z�씫=��՛����6�I,��������q����JF�[�k�SB�q 	�Ԅ�+c���,f�ˢ1��O�o���o��      >   �   x���Mj�0F��)�(tQF̏~}��d˖I����UK��B]t��ޛ��0��z����Y�#���w�����t�܄�N�/0D��l>���W_��a݆b��m��RH��]�6' 7�� a�	�z6�|��;WsN�2_�>A��6���f���}��A5�Ĕ��	q����Ğ�Z�8At��~���ڬx�)f�r����`��7P�j�      A      x��[�n$7�}NE�(0��MO�b0����^`1�y	޶���R���{"K�*��=�)ð����d0�\��hG�����p�bďn��j{&_�]�y?��u�Cv}������M�x���]�>Y��iQ��?�!�����ҭ�7�{��,}�3%�=�1f�M��H��p�R������S�`�..�O�.� K���܆7(��i3����̦vq�G��gI���t��OX�q����e��3r)nY�/�B�l��b�f���=�ު����y�=2����Ö�̥�b"�j��0��0�����s�/����������㣽a}�w��̬i`}��B!���4�#��>~|Иl�7�/�yo@�v��V��N7V"��я�c/#-��ûo���`"]맇����Ӂ���s��'G>��1�B��W�Q�u���BzsY�E���m2^��S+K&qar�a�7xw|���[�����x��_�ܒ���&����p�+�K�D��ǟBN���L�4'����~�;y�/b5�ZrhwK�s�L��[��o� º%�ʳ��J��jjr9	��sF^��:{����?�X?ߤ�<�5vv"�F�9��&~��Y�6s�Gt�%Ұ�w�u������a��h3�ęb� q� ۞�R8w�4a�|zi,rW�o�^d��(;��-G��]����K�12�᷻3� f����!��،���4�r|u�F���
3/j=o�ql�G|���!i�{��-�M�RM�)0��d������E�E�{ñ�dC�&�1i2Me�j�GjՆ�'y�S<��G|�0�ч��um;CCBB��>��a���5�x�@�Z_Rq�|.���|�,�z-�Y�>�pRr%#�!���G۴9[~�2^�²F�����'����I0Y�C��]j!��^p�Fr���;��/��[�r"�y��<R5���v����E�Fֽ
ɭS��M�
 rh�7cc��N	5�K�՝3`ĭ�3��:��l�d����@�T���zM$>o�٫���N@�����U��x�
����DU�[�E1���D�r�U����	JV�pa�\�$�ж�L�%Y�s�'���"@r�=C�1m^T�.�k�T�FUb���(:F�@���O�A+��A�ţ�V�Z���\��*�=Px��A�B�
�1�D���5v7�>R�E	d���@�g�� }h��8����Q?^�\p�EfJ����3�Z5	�gf�P��L��v�+V��}�q���`��˃�j�e,wNP �Ӓ5�# W�A&<�V���*����Eҙ'��$���޻����c�Z�q��ե��	��a�bp�NN��:G�Zga��7"΋�뽾<6�b���H3y������8���$�	������A�B�{`j�*kJe_=���~�Vy~#�\ƛi�S`�k� ��WЫ��K�6ɘ�&�1z�e�]��au�4,<���R�$��M*�^X&7�ݠ����)V��/Â��	@:�|� �����y%�TƄ62I@��0e �Z �ꮁbľD�[xrPP�'xP������n �eP�K�o�_�5�C����c�F�;4'�T�g���5�G�"�9�K0WQ -I��Ch u@Ҩ�hB���E"T�k�f+�\�Ŧ�W-MR@*�Ҕ&R�v�o_[.�;��x��:L�M�`;Y�C�֠p����M+l!�����_#e#6��5"��� �t�\�h��VV*�0g�?�bM���1\���n��Z��G�YnR�p�3�*�w%�Ƹ���E\��:��r#L��+�eC�F�V��I�����!*�R	n�̍Ta�&���5_���ϋ!�v�{���I}f��CH0 t�c�*-C#��o���48q{�|)����ىƆ�	�6��t�w'W�z���-z�:�u3,)fFX2S���L�%��������b��/��H�a�jҚ���6	��G\et��◇s�,>能T�4��f`�$-�ZM.�:J��σ<�����w|����b� �����Xg�&5l(|+j���V��#���*��$3L�Kl|��Q��i����I*���g}���c+��j���(E�j��r�H܏��y]��ܺ.�G���:5����-���'���8���O�N�>��^@�٩ t+)V�X�9%�d�����ֵ������Bƒ�WՔ���?W���P	`@����I����U8O2��� #s�5C�+=5vm���nQ�d�!��f|�XO+����S�0��,���9Q�(Ur,DH�$>j�:RE�6P�U�|7w�≾h�u�5`�x򬸛"$Z�P�}�N-HYg����-ڻЇx���Ǵ�%y
��,M�R	i *����<���<能!s�{���-�܍�ёK�x��>�N������of��"ߣ��D>{m��#��?N-������B��8_��z�����<���/�ZR�ܬ��P	������X�@���0S�/4�Rd�8E��|��5���2܂���F����<X�G�8ɀZ2#:=�N����H��'��	 C�蔽�\�(o�!c)�S��=GԆV7��9C�-�#��kG��>�2:GA�^�?<+�[�jf���t�"
U�p1ݮH[J�U �k=
���d B*x�o�^~������5"*H��x�N��U�W�.0� �6B��<�$=ɺ���B` ��L�Gf��ba�bk��dG��STl<���Q���,�\r�`!X�*�.4#��ۏ�Y+�����wa:*��
�lV`' |d����e��'
@������ԥ���T� V'ZN~���\ðsX%�+����w+}7۵�s�zg�b��d	oC˷:8|8���
98�n�@����%eƀ��k!���<�YZm:�d�m��P�:j�6�)���,m���F�I��ˇt�q��u:��w6)�U�4�90��,�m�<P�|��*���� S�g!,٧?v?�g���O�`�����'�!$����Q��
'p�6��n�i�
(�m}�&h���*�^M��1�|�p�z������8��Qw2a[f�fZֱG�$	^-�s�w3x`ҧQ��j�v[&�w�2��^�����%(b'a�E���T��WQ�,����zXU��j�Xbi�D/��@5���sVt$šOS(jGJ�0���<~�)�M��ʠ�	�(ЍXث�����h�`������)`ȝ>�͞�:�������̠!G%�C%r����ȯ��[�W��,2��0 OÔ���ج�2ֳ(�;��������z�]t�' ՛�P�$�Ύ��M�G�`{A�s�	�ŀ�ӈ��l�-#������:j��t�(P�ŗ\�3����o�y4�m.`���7;�k�Y��Ljݿ:���s�������� \��*�T���?'�G����' 貎���G��F�ۈ�)В�f0��������>�BzO&(�H�X�����Pf�<�ӥ-o��$F֋GX��c	=M#�޶,��Z.�xe���a�1·�$�TD �h�w���}��_����^�>N��C��'���~@���埜6�N����r+�.at&]眦M<t �&��	����1��΅��M�	 ��z����7�`l�:�Ǉ'W�V���q}���]�$�p��3#g��އ�<s{�ky?��v+l6�FP���� F�	�6�[eP��*$X�͊x��mѣ����mAG�b7�J��_`uO�x��G��}J譜|�~\Kb�=N��|B����1�~֖�ʓ��9 022�m�v.��~��S!O!�`:s��^�9g*��0����z>�Z'���d�#��Xrj"����:'��	v�6���0O1�GS�'�Ė����,+�d&d*�<
�?�y�on�iΓ��cMr\O4sm���K���Rԡ�xu��ͪ�'(Q(@��,=`z�T
�� ��Y��qy���=��c��yBY �  F��
�����3Zj'Ѹz3��[DcJ�c�^���
���-%�ئ��Y��	����ݢ`T�d3�*
�UP���� ��Ӕ�'>�]�����h�Gy:VEa�A�$m0� �����Q����SUvH���g�x2
Ŀڿy��4��3�B����NՓMN/x���d����ËK�|x�Pxِ� ��:��+���Q�Q%�xn�����ڏ��8L+@c��q�C�RjJ=��χ1� `y7���b���x��]��<,P���
sn�)�z0�~xÄ'eT~��c�p
�4��i9��Y>ϊ�_��@M���S��ɦ�3P�G���$�u��x���o��`�ɴ6�:�H鱌@�A�{����u��yxy�i�%ϑX��8��	�!Q8���SnIo���j��^kN���A)�h2�1���C��/���������	���`Q@Ӎ���-	��^^�(_tU�ZLX���(a����[�N@c~�\E��|/b�E ����ELk����L@D��~i;���:�x��+��a�d�aI�]i"��ل��&��,���w��~��ç�����חq�0�AF-�9����m�7����Z�Rb�CiC�IZG~ƕ^[tҠ|^�E+{v-�A��i�)��v;�{��i��������� �}��      =   &  x�e��r�0 е|�w���	��U�Z߀��`�A@����׷θ��g�E E<F	'���e)+	��G2��w���]H�+�S�{a��4��\ѕJY��W:��������iܦ�.~��)�y�� "�nf����|!��DGf�ОB+�YH�˳h���g~�e.J?�������vx����2(n�h���$/����?]�Դ��n������QL�=ʣy�]'�rN�������N���eLUT��#up.^��9f�^=x�kS���``�1a�;��5M���m�      ?   �   x���Aj1е��}I��9K7c��i!�����B���Š=8ieu#ើ~>�5m���=��(ĸ V�*��{C�1��@(��i��tn�!֋`�S.b8	�[��	������������>2��t�h/�\`Q���~��� 
r���I��eY~��P�     