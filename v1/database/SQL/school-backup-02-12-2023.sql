PGDMP     (    #                {           school    15.3    15.3 "    ;           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            <           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            =           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            >           1262    16554    school    DATABASE        CREATE DATABASE school WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Arabic_Saudi Arabia.1256';
    DROP DATABASE school;
                postgres    false            ?           0    0    school    DATABASE PROPERTIES     N   ALTER DATABASE school SET default_text_search_config TO 'pg_catalog.english';
                     postgres    false                        3079    16555 	   uuid-ossp 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    DROP EXTENSION "uuid-ossp";
                   false            @           0    0    EXTENSION "uuid-ossp"    COMMENT     W   COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
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
       public         heap    postgres    false    232            �            1259    16992    students    TABLE     M  CREATE TABLE public.students (
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
       public         heap    postgres    false    231            �            1259    16971    users_schools    TABLE       CREATE TABLE public.users_schools (
    user_code character varying(11) NOT NULL,
    school_code character varying(11) NOT NULL,
    role character varying(250) NOT NULL,
    status character varying(250) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);
 !   DROP TABLE public.users_schools;
       public         heap    postgres    false            6          0    16979    courses 
   TABLE DATA           P   COPY public.courses (uid, name, teacher, price, school, created_at) FROM stdin;
    public          postgres    false    218    -       8          0    17139    payments 
   TABLE DATA           �   COPY public.payments (uid, school, user_code, user_name, student, course, course_name, unitprice, quantity, amount, created_at) FROM stdin;
    public          postgres    false    220   /       4          0    16961    schools 
   TABLE DATA           M   COPY public.schools (code, name, email, created_at, license_end) FROM stdin;
    public          postgres    false    216   3       7          0    16992    students 
   TABLE DATA           Y   COPY public.students (uid, name, birthday, email, phone, school, created_at) FROM stdin;
    public          postgres    false    219   q3       3          0    16950    users 
   TABLE DATA           B   COPY public.users (code, email, password, created_at) FROM stdin;
    public          postgres    false    215   �E       5          0    16971    users_schools 
   TABLE DATA           Y   COPY public.users_schools (user_code, school_code, role, status, created_at) FROM stdin;
    public          postgres    false    217   �F       �           2606    16986    courses courses_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (uid);
 >   ALTER TABLE ONLY public.courses DROP CONSTRAINT courses_pkey;
       public            postgres    false    218            �           2606    17147    payments payments_pkey 
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
       public          postgres    false    3222    218    216            �           2606    17163    payments payments_course_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_course_fkey FOREIGN KEY (course) REFERENCES public.courses(uid);
 G   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_course_fkey;
       public          postgres    false    218    3226    220            �           2606    17148    payments payments_school_fkey    FK CONSTRAINT        ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_school_fkey FOREIGN KEY (school) REFERENCES public.schools(code);
 G   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_school_fkey;
       public          postgres    false    220    216    3222            �           2606    17158    payments payments_student_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_student_fkey FOREIGN KEY (student) REFERENCES public.students(uid);
 H   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_student_fkey;
       public          postgres    false    220    3228    219            �           2606    17153     payments payments_user_code_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_user_code_fkey FOREIGN KEY (user_code) REFERENCES public.users(code);
 J   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_user_code_fkey;
       public          postgres    false    220    3220    215            �           2606    17000    students students_school_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_school_fkey FOREIGN KEY (school) REFERENCES public.schools(code) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.students DROP CONSTRAINT students_school_fkey;
       public          postgres    false    219    3222    216            6   �  x����n[1Fg�)�4$���[�n�Ե�DI���)���� ȋ$��픹/q��T�Эtp9<��I2�hP��+	lf͍�Cǂ�7_o�u��x]�\���*mj����i[�Sj��0N���@��$�i0v �ԝ�;��)��|C����[تj��Պ��_�R%ʴ��~����O|L���Z�M�}+9X_�!C�M9C�"�X鬂��|;��wrz�o���q�5�OO���t���:����� �zk%T.�-`�(Q�9Y���'�����?�e��XP��R!�t��n�qr~��S7|������ӂT~@L\��t0'Zl�k�6��5Ğ(��ku�Y|�~�Z�VR��^��6g��Cq�z�k�������
�2] ie�%v-�~Ly͢�x-s/�f6JԃUݨ�8��Հ�Ba:ab��7�*j[3f�O�f��]�$^��L:�/�4�8��$�;R>/����R      8   �  x�����G�뽧PpArș�:)S�M3c�Ÿ���ȋ�.R�\�%��	Wƥ�/�pRi�Ώ��qz��!4Ti��0�Js����}=`�KB����������p [(�h)4(�2�@-�`J#��m�e�`H��Y� �Nȱ�ڨ�6"Ƕ�x��ø�}�㶍%"��m# ��}�ʪ$9���n"��,b,$�ܰA(��:��W�i6=�*�
�0������4�^�������/w��X��D�$�}�k"�7�Q�u��L��!���+����#Ib}�@�,���^!��)�jC�o���];ޕ��??�ݫ������>�����z�$+0��X4�<��(}�>��E��4�Ao���A!�fP���V�qǑ� �y��R�Q\s����w��?J�i��G[9%��1�����]�� c����`��1�Yg_Bb��t�bz k��/�w�7Ǐ�ߏ�O�?,QY�	�5(2�Y8�D!��[���ˀ2�Ch85��X��.�H8��s�H<0��B�n/b�O`�3=��bW#ɚ|��No$�mw�!U̴?�ޜޞ~ٝ������������j{���L�JN��0�@��2�]�F�C�uxC�.r���ad/.2tݞ=�G�X��h�����5�g�����.a�["L&�6/q���#��S��g�?2��h�ً��F�T��S�Gǔ��$zm�.2�j.&���M�zR�w��/�������!�=�5�Q6�C��jq�]�n(F=B+���^���Q�	C
���y2�3�ʤ��s �����ʦu�h���P���u�A7��e����2ǚ�s��������m���[.���`+���6ﶙ�;�_��ԥ�MM~g	5+N�\.� sr�����i�������F�R}�w#>�y5����ZᦠH�Q�E
�0hl�/�(3ϑ�VR���9�O8�la*�'�L���=�5���%��zss�h��E      4   E   x�363�M6K�52H��I��,����4202�54�50T0��24�22�35�00�60�Ja������ 0�h      7      x��[]�\��}��z(��"Y��xNb;���"A^�5<#agd��S�g�{ڳ��Ð�W���b��(R�qY�鉭���)~tSz���������g�36�K�w�p��}�[l�.�O֦�GkZ,�يq�~��X��tc��轓�K߈Pr�Ő�h���l~ �w�%J�/?||_���7pq�{|v�1X
��6�A�V�2	�5�M��i�:��Җ?�O����	k7���>���� ����<)tJ͆�x���a��V�(�|{w�Ps�L��胋���q˂�p�>��RSFz��>m�����?>���0�qź�|>>��w|�L�̚֗��ĴD��P�������dc�q~���{���%߰���t��%���H=�<��}��px��]�?&�H������p�t���������Y8���!����o�KH��5�]���&�E|0�Z6X2&W}�7Ƿ�|���I�_���b����76��.�x}�b{Ew�(1��S�dؖ*�ss%��O嶼���`-�ߵ�%�9|�����o)º%����H��c559ANp����9#
/�^-�E�~|i�O���oSH��[\)�F�Y�i?��Z��:�]}�4��{i(z�6r��!Z�83Cx n�`�oP2��.�&��O/"�E�2�-�s�ev��?�#p�.����j��v�|{F��>�ہ!��q����&R��n���0e��c�y��c>���RH{�
����X��3�Z��ñ�u�i)�����dC�&�1ie�� ��Ԫ�O徜�9Y�yo��GN{�y��	Ml����<�kF��n�>��B�R8w���Y��Z23�}�I���L�h���is6y�2^�²F��I�ɽc�c�BL��РaF�Z=�g��ܺ��}��9��%P~�XN� �� �T�����u�G�ȺW!�u�%x��������(5�YBwɺ�s��5�cƙ[G~$a�FMF���IU�=Ѭ�D��&��
���4�y�
M�[Ej��)l�i��JT��uY�Fp�D�&�X�WȐ+]e�H���d%�A�uI�mkɴ�P�;Wy����Hn]�'(9ƣ͋
�	�fM�hT%����c�
��H?��t ���	�G��
j�k��	�	{���3�.���%b�D_��5vo�|���ܔ���dA��p�p ���#+~�H��\�����'Z�f̵j��P��L��v�+V��}�q��(c����j�	�;'(����iɚ��) W�A&<�V���*����Eҙ'�}I���wC���c�Z�q��ե��	��a�bp�NN��:G�Zga��7"γ�뽾<6�b���H3y������8���$�	������A�B�{`j�*kre_=���~�Vy~#�\ƛi�S`�k� ���ѫ��K�6ɘ�&�1� ߄k��kX]m�O;��T1I;t����.��n�n`agr���/Â��� �J�W������[�y%ߔǄ62���9�a� 6�^�@��]Ĉ}	�6��䠠�'xP��Hh`}7�
�2(�䷊�/ P���ҡ�_��>z#��	<�����*P�2R��>C ���	�*
�e�ҧ�@�4�'� �31�����ي:Wa�i����.M�@*�Ҕ&�{;j���Mr�N�1^k��S}+p0�]Y�C�֠p����M�l!��Nk;b�FSl�GkD��'�A.5�6����<��,W�a�?I�&��cl�Fh�_%B�0�#��oV�[��=��L�
�]��1n��pWA
�_-&v����B����ǐ��+��I�����!ʊR	n�̍Ta�&e���5_���O�!����nQ�I}���!$:Ʊi�����!���}�=Nܞ���$G��~v��!c´��8�������v�^�h�K��Kfr�:���X�������X��"���)֫&�)�(k+�U�G(������(��`���T�	d30q��b�Fr�"��P�|zT��>���H�z����o�S�I
���xl�զ�Hdl(�
���	s��ϖ�6r�3-�v�=J��6��vW~ly�VM#�eRF��E,�E�ޕO�bM��uY?�0|���<:zb�t&[�X[\��p[ny�u�P��n�"�N�[I�
�R�S�NvZx����Ӻ������Z��XR���rT�K5���� ��;ܟd�-P]��$�`�d�DX�1Ju��Ʈ-�.���AF��ٌ��i�>u������c���(rG�Z$f"��$>j�:RE�6P�U�|?�O≾j�u�5`�+�䢸�"$Z�P�>j�J^g�����-ڻЇx���Ǵӥ�R��:p�� TLm��y�Ey��{CJ�{���MP����ȥw<��m��T��b�Mr�73[T���\c"���YC��I˟��ҁ��_�^�{j��SK=��``	M��K��J-)]nVNp
�MXU��/�o oaa�)�g^)2m�"\W>���D�n�Tx|��Ţ V~�'�Ck@fD�� �i��u:I3db�Z`(��'�%�B7��{09x�sDmhu3?g� ��`�{����{CF�(�����g�pT�lL��E��.���iKɺ
�u���G�^U�� �BH�ߖ�o��y"��;}��F�
R�(ޡSE�rU��?�����F��'Yw��[���	���,գ^,�_l���eqT�O�t{�}�^� 'gi�,�W��х�fd�|��?iŠx���.�AGI���ྀ�2��O�9a�l^���P�����5u餻����D��iu)5KQ�*��X���WE�[�1خ���c� �;�^'KxZ�Ӂ���)�V�� �AMs�:W/(3,`,�f��_��q���v��N����V�h���X���&(ǟ1�8H�^_?��]���ب���,���XV�x�8��^��8�]�@� �;�U���f �z���d�:���x�咎;>��j�Nbt�P��pj�EP��
W��ݰ�tP�y}�
&h���*�^M��1�|�p�߀^��>��4�{�]��-�F3-��#@���9�<0���x�h�-+���00�z�RX<���KP�N���?���+����cQ�zXU��j3������;1�j����<lё�>M&	&�$���a�~y�Tf9mҎV�O F�n���^=$8<E�^F�#ߗ����<������9�+TtE�rĐ�@;��P"G=����ϻx-�Ef�i���bp(Vt^�zUnO���:e��Ax��X�����H�Vh��?ygGy�צ
�#`�������$a�Q=���fDU�~�#6`TG����NTq�Y�y����53�����L~@ð�:�F�U*�Z�φ��E�f�b�zA�F�2 Zz-6W���?'�G�ᖢ�O@�e׋SlN�n#�'CK�*`��ˣ����}t���LP!(�*X�,M��Pf�<�ӥ-����T
Y/!`�N�%�4��{ۤ)�\\����a�1·�$�TD �h�w����*�~����>�}�VbঞJ]���ϒl�rڴ:m~�ӆ˭X:7�љt�s�6��e X�h�G�:v�W\Ǹ�:r��6]'�Ў�AzD�ސ�����]�Z-������fwN���I��#N�CC���=鵼w�t;��
6��#
�wA�`ed #΄�V|��2��+$X�͊x�$6��^�Br�����b7�J�˟auO�x��G��}J�>B?�%1�'�z>�X�v�{?kK��Id�	�6O;��ܕ~��SAf!��2t�<��2zsΔ��a=��|X�N��'�ɌG*Zbɩ���C��7�&�i�����x8�DM}��J'���n?~���9�������D�<�y����9Oҫ�5���x��ksM_z��W��]�Ө{pnV�=A�B� �&�/`a��;��9�)�n�']����wO@��W����	e ,  �^+Ъ�J��h��D��Ͱw��)%�{5$j�O������&Y�Tn�	����ݢ`T�d3eN�*��������q�����hװ8Ƥ73��<��0`��}������|(����Q����SUv,�8���Z�dd�����i$�gb�u�G;UO6y8���sH�����K�|x��lH� ��:��+���Q�Q%�xj�����ڏ��8L�@c��q�!W)5�H��ØuH ����h1������zyX�Hv9����|=�A�߿b�:� #�F;�dZNzx&�Y���	�v�4]3��V� E|$�O����[�����a��l;���C� )=�)Pr����A�:�@��?���q�"s$�k3N+dB$� �|���VY9_���k-�Is�:(�M�� Fۢ>zhU��<�9^��>�q<a�a7,
h��C���p�õ��=�W]�SK�JX��3���+�1?��D�g8ߋX�!��U�"��Cq��e& �Sj?�4��li��!���)ꖻݰ��|�������      3   �   x�e��R�0 �5|�vN2�IH+G�҂�B�G���*������Ό *e�I���׃���`J����x� �Et��7v��S�����Y��.$=��QJ��)��]��͗}6%�! D�dLXL$����$ೆ#Q3�F�k�I[�+Ӗ����I5�bի����t'vy����u1_w���?���ǃJ�M��]�Y�٣��8�Xr\�����%/IF      5   M   x��1� ��{��9�{D8y�"��&����ɠVo�;BLЖ��p}g�Cm���`�����Њa�s^�#(�$"?���     