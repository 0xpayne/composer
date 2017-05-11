(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
if [ "$(uname)" = "Darwin" ]
then
  open http://localhost:8080
fi

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �Y �]is�����
�~y?x�m���6������[)v7AE��5�d�Lb&᝷�'���m���uN�t���+7^���)@
�4y��4�<�������EEQ���~���3���dk;�վ�S{;�^n�Z�?�#�'��v��^N�z/�Y�ӟ�q��x���%�,���!�T�/o����;����GI���_.����^q�޺.�?�V�_~��s����e!\N��Ȋ�e����Ӊ�ag���=����O�����E������<���8^���k��P|���b�"��y8eS.a�4M�4�:$a��"�#��~���ڎG�.�">��d���*�e�������I���ǋj�K)c�p�u'6d�&�B�z�lC��E�T)M��(�2�I}a,0���F)�[e�ւ6U�	�e���i�ϯ}�`!���x�	Z��Աc���#��sݧ(��h��:���OYz8�l%�n���Ri&������Ł��"�-T?�%�^|��}��+��K��wO�o�_�ۋ�K�O�?w/��(����J�G�������:��xE���=��8]��R�@��nȒ�b�V��2�4x���2BYS����ޖr<k.�m�h�ͅ�j2�u{�&�*Z�C�f	��5ļe��7�@�9��aRf�[7"��
��긝�0i#��=də=Rg�A���?<Qd�a.�9�ĝh��&�or���s#w�p�W%W�׃�(f<�(����,�����y�7Me'��{~�N��"r����;i�:�̢n�5�H�X��`a��� ď�������E�I>�{o-�+����g�	B�B�ӛB�D��bD(m����|7�Ȕ�	Ӱ��X�1je�>�����f9+�d�r�v���,7Gq�;S��kQ�с�@��r��sM<�<���i��b���B���R�ύ%(��}$��t9^eu�Ș��6|#;��a��l�E�$m.o4F�t�4W��� %�(‗5����e�Ob`���1f��:���a�����w�\��$mIm45Q�Xu�!�%�H�X4�9����l���̆g�����r�K�?��oP����(V��R�A�T��xU��O�?V ��/��qV�'���:PC��f{��W�d�%��'�s>��v<�3�8N
��F�D�B?ҨoW����٩pP��*�*HvQV�~�Wf�}�"�;� Z�XX���+9$�MY���q��h1Qt+����)�a�P_�&N�&.�n������2�C���4���j�NZ�b�O� 4��[�.u��z��3w�V�J�BxR�=�5af[8��Q��4M9k�m qyQ�:�W ������k��k��Aȁ3_�A7��}���|Ƿ4�צ����4���E#�9�u �-�5�)��̶��	�4���qG�"j>ob��bM�CAn�{�I���sn
��L�k�t���mfՇJ&�����S���w�7h�w���$���R�!������=�ќ����������?��������?��t����/��3�*��T�?U�ϯ�?�St��(Fxe���	p�d�_�!h��Ew�e
���E� �h��H�����P�_��~�C�d������vO��M
Zy8�XOP�Yǳ�>Wx�qpa��Q��Ë�?k�؂m�
f�dܐ����[&_z˖2�'�!rXm|�1�>��:ݎ,h��ܘ��%���_�[P�	v��lO�*���%�����*��|�?<���������j����{������J������������R�������
���#��fk��^��������]=t�0�>��q�31��B�v�d��*��< }d�ex�I&��T�[ӹg�6|�=̝�*"��"	s=����z���dް��1�?M�B�x�]�p�r'�v�ó@���5樶ţ��lp�H:���stNnq���*�*�s����g�@[���`%N��;���g�m��I��(/�A���{�?-L{�dф�NSD�>�1�?��h�������Np���Y�3�ei��@y��1�TpD	i'b$�#�����HȜ'pr�CZ�?^�?�/��ό��+�_>����S��RP����_���=�f����Nv��G���������_�����������������������?�zl hQ�T�e���16���ӏ:��O8C������빁[�q�%Pa�a� !}�Y���*���C��<��	������*vE~�Z������֘.�m��H�n�����'/H���?�@�N�ǝ:���А�Q����2�F�	�6v�3�J������nO@�C���V>����3�pN)9��ͪ��w�1�ǩ���b���j������ߙ��?T���\H��ח	���T�����Px��e�p9�i�*������K�A/�?��Tu����?�/{z��C�t��S>��Y���ň��ǶI��)�B]�B<�`Y�����w]7��%� p|�eX�6�JC��|�G���������?]D��� �D4L^L�ݠ�nci�x�s�X鮑&����V�p�e���+�au]��S��0"7�3�`��(�|�G�|F�T��Nc�[����&���k��3[��ލ���������#���+������S��:��T������A���B�D���+����oA��(�����_�=�s�@��8�Z���� sߐ���>:��$��}�g�ݏ��{P����]P�z�F��=t���y�֣<��]"��恆��ph瑉��OsvJ���y�Hw�m�3b����j�66a�'�E�\�n�Y=�c�1<�j2�:�޼9��\�t���[q�\R|o6h&*�n�Q�z���b��G�������s���X�s�%_���ԕs[�(њ����)�,Ԧϩ��;�t�3r�¼�kԥΈ$������>8�k�����9�ۻ����=��"�v6�8�9g��r����b ��P�0�)��v���K4�[�3ۧwKkUׇ��9^(i��Ń}���8�;����R�[��^��>��P[��%ʠ������JT��K�������� ���5��͝dv�
9���D~���P�'������7��������9�=n�C�j
�����m���䃀$�H���PwSR������ؚ���ms�ѷl���D��!�5S9v-Mhҩl�$��ԺN�t-�\9N�j�x-�4!���A��}�R{���Ț���	�H�6k��y�^wӾ�R󬑬�R��S2���k�g�`�r����߃�N�Ѱ	#$�{Da�6������H��R:����&���R�[�������OI���6��9(�����?~�ge�>���j��������(�ߕ�b�+P}�s)����[w��B�*��T�������s��o��CQ����+���#l�.4��"Y�eh��(�	�	� �]�}�pȀ�� �}�r]�q����V(����?��BR��O)���PZ�d��a�2�f�����9��6ض��"o䑶hQ����hN�m�`]	otw�K��#`����;VaDI�1�ַ����0�k�d=�(G��b(���:�b��W��/v�~Z��ę�����?Zp;�$�Q����l�4+����_�_���v���W�Vsm�x�զ��_k�}��vl'��W��u�P7q�^#�ȕ�H&��3�r;M�e�/��Nj���8]�oxp��*�7�_��{�:��OOL�t�}��_4B_��u*+nd/���lR�rk=��v$�vU�\w+��¯�z�'�оot�;��������y�+�v:`���7���]y�)�ƋM�?��k���n_����\�ӥ��,��X�}s�T4��nW���w��,��f���.����4DU�A�#�Q�����7����b��/��hv�oGھ�T�;?X��Z��u�i�]�>ʵ�(��˃���{��{�@���ւ�?A�%wۋ��M17\G,��^d/?��&-���������C~��������O{ӻ]��o��yW�=���9�[~�j������;5���t�x��k��5Ɖ���Y���t=�8ׅ���=�ڽT{X�D29
B�GB�,����}��#����Wdq��4�X<��^��6	���7|�*��q$�C4dE��o��y�VGƷu���J�3B�+�Ʒ�r��
��$����N�t��ϖ�u���O��ź-X���=�*����Ӌ3O�����u���p�\υˡ��2f��{�t]�ҡ"]�n;]�ukO׵ۺ���;1AM�	&����?1�OJ�F��|P	4bD!&������l;g�p� ���=]������=���{�g�pSn%d"v���D2A�")<]F=�Y#�L&���LG�a\��e�����I��,��ޗ�t�[]�o���4+�cѥ� l�^ ��k@�>��g6�	9�a�7���-�,IrO�Ʒ��_�5���'W�]��r�̤�a�E7 �G�o0�`5S��#KFl�M�M]�{�*i ����Ǚ���9�%	Jog4�ɎtH��l!��h�r>1��z��Wَ�~�x7�sF#-�&��q��(���4b	�Y����t6ZV{߬�s�<�J��Ґ1˨�
ߪh�t�j��E��Y���Ma��M��4�"G�ӥ�l8���hpꛃS�N��N''F~0��|D��urubG�bre�%�EEb�*wZ�E~��\���c��j���e�uT��_�2�&�t*i �H�s�o��C֑�����9��S�l�k��f$tQ5u�~������G�JTx�Sk�Q�!�}\������|��.8�s���#U��2�d����M�z�b����\4�([T)E�������.לP�Օ��М���H���=����L��*�T��Ǌ��x�y>��܃s��\��M��ɏ9)�@b!Cf<�Kp���:��2f�mN̴��6Z�w:��Υ�Sm�}I�+���wu�^�]�_�nu�z!G���^{�#Xvu�NN�+zQ5�g�f�Ш�8��\^ �=��b����v��*c��?n���g��j��g�y�x%���֞��c?��y���F�n���=� �l{Q��G�ض��� ��l��U�>$`�
�����PN���!8ix����ۯ�q��p=vk5�������v��?z��P`�Ѝ'(�gNp�8��	�~' �qq��;7~t\e>s��9�s3׿� Rc�36�O�7���7�9#Y����z7��yx/*r	:���z�Gg��1��<'̞��i~"�{X���;��l�Fa��^����j3������c��[�6p��gH���"��vz�p�6�, �NY���/���Ur��a���y����झ���b4^2H|��͜l�,�I"�6:��s���*�a����t��v����d��"Y��no͢ʤ����il����LH���V��{�o��\�r��bB�3p)(��BB�*��L�l>��^JM)p�뭗B���~�>��S6�f��L�U����"�v�@Xj_�Om�#���'8$�f����bX{j���[�[��kJ6�ƃ��VqW<�$��6�.s����8��+�(Dsy��V�'�ܑPR̄�l��'$ q8d%�a�I#�r
fZp$B�H��Z>�!���1��9d�;�M����V!�Jj���v�V,�#�?�4Y��y�ZJ�Q�\����a�����`��N��\��w�C>?�D��F��W��1)˒Xg�e˝��u�@�Kq��R2��D���L~( �j�@�~�kE��`�n�H�_	��X1��T��D[i�"T�����MNYpF��ZQ�"t�����i��3-)5�,{�gd�*KT��!_���}C�к|�nX9��0vu"Q9�	Ǜ��#����bλU�~p	�T2R�#�&S��
դ�K�}�����*Kl���(Ke���,Q4��
��*\%I��B����Bg�5s����4Ϸ��P�jW�Eyk'�N+�*op;�;�Ĥ� r�}8e	�ɚDp/��2Hz#LʕΔ9�S�=�3�K��	m�ޡ�{[�Z��BI`�7�ҽ��� XB�y�	7�C��[ �ِ���kM�kR��)�=C1�M�l9�nO��i0�)����l����V��6N�F�Os����Zk�}:�v%��A���'֮�8]7�*me��tr買O�Y��L�Y�r��4�VU��]� ��D#�.w�Ѝ�5�j����,���B���A)Y�q�&�Fp�q���%itr�Np1�)�y����O�6U���~�oi-;Pxh:Nj�$["Np�Y�Lm�C7C�����?��}�a��L��9g�3kWA`�{��%s�4(�yV�U̚C�@����Z�c�~V�Y2��2����>�s��i\Q����y�e���a~�yh�Z�(���3rBg W�a��G��cd�+~�C�qyy{zk��������`嗂��G&���I(�L���D �
w�<[ٹ��c_x�RGB�-u4gG����`4(Y�y�S�.8Xڳ���� G]ppR+`z�՚2�pO���f"�'�MMpgHmJ�~���6�`V
tQ&���D�?$Zq$B"���$�A�[D�l1�<�ם�d�Nj\�W/����ك�A����h1A��Cx$(��c|�4&�CҸ9d�����p,Q�4L�u{��p������Z�d����4�����t�Jܯ�-e�{���\�z]���a��N��S��l��I!jAu��,`�0Iz�����q��{��kN�8l㰍� ?ֵ�%�ݦ;��L9��h�L��L+�@,���]�֩�C���>���r�a��ߺr������=,�e��H�'��� ��
���R��D�\�L��y�6�@*opdw��A��RT��<X=(��E&1pԠȤV`��֔e��������l0�Q�JS�N\�Ai�$S8"�S��\�	�(��|��0��J��!�r{:�,w�������RJB�����!{c!����XQ�n�a��v9L���R�oG=;�A)ʓC��D��FP^�˗v���e��>*߯z�TO�r�PF\p�I T?�Ì>�Е-����q��51�%�p��M��r���t;�$��K�����+{X�q����f��~ܳ���2�����+��V
ɭf۸n5�v!��FYM���L[�p�jF��������M�RQyM�5��n �ϐy-��`}|S\d�	b��5p*��^�qWꕻ��F���q:]a�����z��߾��z�O#���z���~ח^���o����5�j����i6-��~�e��D�{���6��$��p<��~� �}��?���O?��o�����j��Oϟ��O��w��n]�����_�\��m^M'�U�����_�ɏ=���亂?���k�����7>�$�:^��?RП���/8�7g�����N��iS;m��M����W���W\; m�mj�M������f�l�j�����z���Uh�~p�0B�\���5�E��I�c �[������>�~�������kSԄ!�g`�u6����jJ�y�q�������<k�r�,�뵩i6�<-{Όm������i���8l�sf�0��S`.�̜��;DhmU��K=F2�q�K�ZW����Nv���޷鿋��  