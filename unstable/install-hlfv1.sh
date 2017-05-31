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
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��.Y �]Ys�Jγ~5/����o�Jմ6 ����)�v6!!~��/ql[7��/�����}�s:�n�O��/�i� h�<^Q�D^���Q'1���/�c$��F~Nwc����V��N��4{��k��P����~�MC{9=��i��>dF\.�&�J�e�5�ߖ��2.�?�Rɿ�Y���T��%I���P�wo{�{�l�\�Z��r�K���l��+�r�SBV�/��5��N�;�����q0Ew�~z-�=�h. (J҅��|R�N�i����(>f���b�"��y8eS.a�4M�4�:$a��"�#��>M��ڎG�.�">��d�5�*�e����)�E����#���ſԐ2���WGpbCVk"/�A���&0�Z[�Nu��ty���,#�.��&���[�j��Z��P6m-hS���Zv�)�� n����W�،���@O+16)=�;�|<7�}��QQ��:�=��񔥇��VB�F��� �f�OX�z_^Ⱥ,R�B�#[�����ڷoЩ��*��5���M�K�����������w�]�������]����u�G���G	{��	��������Eݐ%�/���e�i�<p�!�e���,%>���-3�x�\���2@���d>��4M 3.T�,�x�LMk�y�DC)Ё�sJ[ä���nD&�!N;�q;E`�F�{��3{�Μ��+�9x��n�\�sv?>�;� =.TM(���Q��F�N�$"�J��Q�x$rQ&���}Yn	bG�s&
o��N< :�94��:q���[{(���\C0��)�p#ica���1���8?�.�B~A�'�xh���Tn�pJ�۟i��B�ӛ�B"N�U1"�6o��b�IdJ؍�i�v�k���2uN�em
h�	���\2T�p;ByWZj�����՝)�̵����y
 ���r��sM<�<���i��b���B���J�ύ%(��}��t9^eu�Ș��6|#;��a��l�E�$m.o4F�t�4W���%�(‗5����e�Ob`���1f��:���a�����w�\��$mIm45Q��u�!�%�H�X4�9����l���̆g���^�����6�@����� *�/$�G�Om�W�}��J������_���Dw��5��0o�w�~�K�[�{�<�CKn�c�0C��q"T�G�z	�B?bԷ*�!)Gv�A,�
�
�]����̽/S$y�@�� � �Pt%�ĳ	#�y"X�]2�ؽ-&�n�8�5�5�!���ĉ�����]=t���[���^�湘[��A+\�����{�Х��Soz�.��Ti�\OT�Z�@a����h�i��iʙ������E�r>� ����Mf��rB�=<�!�|-�t��������L^��B>J$��O'��� ׁ��C�(��3�f&$���	I4��������5�/����&�f,O`@�Ϲ)��3��%��j���Ur(q��C�����%���o`���?IRU�G)������������2P����_���=����1���?��t��e������?��W
���*����?�St��(Fxe���	p�d��CД�4�2��:F������8�^��w������(��"���+����8؏;���p����.��g	}��@���p�����ֲ�۶̈ɸ!'MS�L���-eXO6C����c�}��t�Y�̱�1G[K|���n�,�F	�6Kٞ�U��{�K��3����R�Q�������e���������j��]��3�*�/$�G��S���m�?�{���
���#��fk�/���0�`������F߻58v}&�C\����}@��r���L�1ɤޛJsk:�LІ����CE�ctW$a��:�;^o�a�����5Q�Ǡ)Q/�q�@�:ܠ�ɪc��,�=Ѻ�i[<2.g�cDґ����9��A�6h�p�4�Cr��mEl	`�8�v�vSt���MV&�����-�3�q�|�0�ٓI�28	LE5�xǰW�|h֣�ZLB6ޮ;-�mvZgiϔ��uG=��f�TS�%������d�R$/k7t !s���IV=h��x��_�����W�_>D���S�)��������?�x��w�w� ���Q���\"�Wh�E\����O�����+��������!���Z� U�_���=�&�p�Q��Ѐ�	�`h׷4�0�u=7pqaX%a	�gQ�%Iʮ��~?�!�����P	��W.��S��+��JU,o86'��t�lc�=GZu�-���=yA
/����w�<��i%���䎢�$���x5�`O@��嘱U��v���u{b"�4x6���MF��sJɩ�nV������z~��)�/��Q����������Y�߱�CU������}}�R�\�8�T��W�
o_��.�?�X%�2���8����Q������a�����?�j��|��gi�.�#s�&]ƦX
u1
�\�e1���F�u� p�`���m�a}��(*e����9���>��t����0Qx1�v�z���`�]��c��F����_��Yh����8��u��RTO�È�<j̄�]��kF�A��!�Sn;�"l�z&⚠:����l���y7>r��t��AW�_)��?�$���������'��՗FU(e���%ȧ��DaV�_x-��}�������;b%�A�*�5��`����,��x����%���?c�~�0�߃��\�[7�ndD�o�ݰ偆�A�74��k�];�L(�|#�S:�X̋�t�v:#������mc�y[�ȵ�f��#<���39��&���k�͛#���L�-��%��f�f�����'�n��(F�|d�ψA��:�����9Z��5��nM]9�5��	+�����Bm���_�SI�;�!qk!̻��!@]�Hr��pY�n���a���&8L9��Ӽ��+.��Sh+��mg#���s�O	+g�O�� r��A 5Ý�i'�I�D��?�}z��Vu}�Ț�Ґ^<�G��������ǉ��/���O���7�s��j+7�D���v��@�*�{)x�������q`�~��[����NS!�����������䙡��7P���A���>9��my�@M�w]��-�_�'� �	!c;9�ݔ����E%qG4�f#�e�\k�-[�)Ѷw�o�T�]K�t*�1I�4�.�S��]K$�_����4^�=M��|gs���l��f��9r5��Z�lޥ�ݴo���<k$���Ž������Z�-Xr�\���������i4l����BEا���<{�)>R����r���*����?�,��:�S>c�W����!��������?����_��W��o����s���aX�����r�_n�]����U�g)��������\��-�(���O��o��r�'<¦iCI�b�d	��}�H�'p&@�vq�Q�!֧���u1�a0���[���b��(��T�?����?@i��-'�}˜�1lv�C���s�`�����GڢEM^<�c�9��v�u%���Qt/YS\��A@����X�%5�Zߺ�#j��������pF�ehr��Lo�W�(�M{h^��y/�؝�i���$���}���g�|��8B>��B�X��_�`�Y���������O�S�ϾB��k#�K�6����Z��?]�^X,��vҩ{��_wuCW�5r�\ًdb�>�/��4^F�r}�I�vU� ���n�]E��k��]�������8]g���/!����u*+&nd/���lR�rk=�G�(�u��(�>�VӅ_{��O�}��8�h��/��dΫ]9��������ڕw�m��D��1��/�������v��k{��ӛ��µo�nnm�ۙ��]�+���Es���.�7Quй��}CT� �b���>�y���ڗ��h4�·�l_k*ɝ���@�w�:��4̮o�ʵ�(��˝���{��{�@���ւ�?�A�%wۋ70:��bl��X|W{���e�-o�� ��O[/�������
��8�?���z����n��A��~+�~�����=�����E�����w�j���2����'k8�{=��ԅ��z�q������Hj�Z�a�MX�@��)��x���&�f����pF�=��é��pls�b໺x�7���]A�G"?0DCV�����-��mUqd|[��q��kF�ue���YNw_a�����)�n��ْ��{W�U������\z;u�r;���[tgo��p
�:N�d'q�����q;�{�|WH$�T$`�"� @� �/@��~�VBˇ�Bh�-Z	�;�'�$3�����+�q��|��}����s�1��ʙ�B���}x{��`��l�:���r��JH�<D
��T:E'b2_f;�Yc�\.����ƒQZۺv�@u�$�b��}ͦȤ�u�fZL�2�n�`�@��b^��ɼ<��-�9��CL��NWW]uUQ��!v��_�51\��@Pk�A.�ce2�aإ@���:bׄoX"�2r��P7�6�MU�����N3���%���)�g<��Ot�B���2,���NK�o��:�S���qμ	W�샙�f��9���9�XFBlQ���<���F�j_4�W���Bi5^�2V5Q;5���훳��)�b��{c��*yݢ�:@��S�,p�6����NKpJ�-��������OVwZ�h5�ή�������$]�uj�z�Q�Cx7�{�:�4:����9���u�M��Lڄŉ*>�z�����#���#
fOgt�|6܏/H@Y����x��x�P��J�DC��Y�)?�2meq��P����%��������3�3���E����u�&�i-P��Q���J|��oX7�{<KB�N_m�BK2��#x���\;���z�b6[�5F1���+�|�ȹ���>I���h�cI
ZG"b�L��e	��:� l��boKb�1���u�'�B69w�oK���>T�5������ӷ;[����:����w�t��j@?�}Z�C�y�(�{}���8�Oޠ�ƆǺ�W����xqs����?��������O�I�4(m]ع���?}�{w��U�Ɠ�X���<�S��ؾփA�K��y�~�~�^��Q��0����0�OD\��#W��}�+?�ϧ������?.�������g�a�;�c�����@8�u7�8��#/<��k�M���א/\C>wm��W.�@j�����xqWZ"0��9n�``s����GⲐb�m&l�5H��x�s��&Y��'�y�Y�����o��Æ�dO ���V�J�F�}ԛHU�ro�[B��0G{�B�S���cN(u�v	c���"YaX��}Ќ�t�<.�D�Yl�g�9��-����G���نn�J���|��? è�Z����!�0����dG�Ā��a��	������.K�\6?j��n�,y�R���|q�H�V�(�50�f�)!�}#���*�������#b��g􌆦��f%T�G�C�|�a�:LX�	�	���1�9a�s�zB��7��D�����R {O͍�u�PJ��lC�Ǽd0�:�I�C���ߥB�U��Tѡ���Am��x�H�R7�i$�@{
N˹(�oy�ŔB��N��47�qY,[͠\�T���D�'��%d="� ;V���d/���#|�+��i��W5��/7��d�f�6O4?و�@�qZV��ZC�7��l;n���d�RKJ<Ǒ�f$$�ر�h���='eY�낲�ys������j%8tF�QЛj	h�+�%�XPx9�	�x��Q�}�k�b�(g:r�	�����k�@�)T�Q����)�)l�(+L���2u��,��d��d������Ze��>2(�l`LSF_L����
A��^,��}�d��I�R�Ѹ^.��>�aa�I�A����A���)y(�5��^[eI�R��
e�,��%�'"�`�^M(�4��@J1��ScoZꍍva�D�Ѡ��YDH��Z�����q�Z�-� �F����S@MyO�,Q9�P����PUi��x����aK�rDxAv��p�]�?�`��CV���FyvP6ZOI>�e�%���-E?P��օ.��R�7�c���Wc�(���˽w��������m3�m�i�7�.鍮�Ȼ�k[w";�r	���u������v&�!7�}�\�m��|��;�ʊ|�TU���9�w����.r?r7�����[�p��E�sPFU�y ��G
��uIE���y<@Mb
Y���뫆�l�Uu/ψ�g�G��l#��ECUT[��Z�k�E�-��-���3�Ʈ>�˾M��9W�+[oB����[��/lR ��ҨY-Gފ����\yv��2��2��������eR�`_L*|�:�s��X�~��:�����3q#W wY���g��cl�A�C>r�$���m�����n��8/�<w��=Yx0m/<�vhJk�j}��B�N�����/-<(���:R2k����`4?4�E�a��þ2�t��ʑg�8낃�V�Әo֜AD����`)1m�X�B{cfWi˴_��1���J��s�h��g�Z�1�Ib��Hs���
K�2F	t���"tn�M6m�@�<�X�g�rdb&��&���a�G�XXʚ���ǐ�fIk�03á�D���=*��'s��Q�4;�1�r�͵=��Y�X<8&��dP�;.�$�a�#x�ͦ[����㽐8d	)ܑ�=���"�C��-�E��Ѽ�"��0ʃlBD�5�c�q8�q��9��A��ʷ�9��Mh����L��l��Q�!(��\�{��v�C�w�ayO���ۿbv�o���=,�m�H�'��� ����J��ƪ-R�\�I����@&*�op�p�X@��ZTn�"�<(B.Ef1p֠ȬU`�o֜e�������b0���Z��3�AR��ae��3$&w3��w<!��h=g�b��a	$�Z�F[���z������h���JF������!Gc!����XU��Q���B�5�J[��}���W��T���pQ��v��U��I�8���L�L�j�T�<h�Ka�0�D�ڞZ�x�㆜�SH���.O�F�Y)���~��4�Z:vi�=,�8��{3�Sy?�ň�FN���N�B�B_��6���Za����!7:R����nO���[��9��iD���t�0D��}��>�-~lO%I�� ���rq���w@p�^yd)�j6	>�����ͽ	lf�/?��:?{����Ͼ�����{����=�=�~ ��U���5��I�i�D�s��D�'�?��G���?oK��W��_�z��������ч��/?�|���<�?/|��ٯ�߹~��$�R|1	����;M���������t�F�A��.��;����?���-����q�_��O����0�%���z���37��"���ӡv:�N�&��j������	H;i���P;j��9>���yj��m��8�rh\����"4ŷEy�*B�,�9C�-�z���Y#�y������KsԄ�g�u�����|Jux�q8������<k�v�l�륹i6�<-gΌmu��8��iΜ�8�sf�0��S`n�̜��;EhmS��K=G2�y�K��wL�9�INr��^��[��  