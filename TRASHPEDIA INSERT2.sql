-- ȸ�� ����
DECLARE
    a NUMBER; -- ���� ����
BEGIN
    FOR i IN 1..100 LOOP
        a := SEQ_MNO.NEXTVAL; -- ������ ���� ������ �� �Ҵ�
        INSERT INTO MEMBER VALUES (
            a,
            DEFAULT,
            DEFAULT,
            'user' || a || '@a.com', -- userEmail�� 'user'�� ������ ���� �������� ����
            'user' || a, -- USER_PWD�� USER_NAME�� 'user'�� ������ ���� �������� ����
            'user' || a,
            'userName' || a,
            '010-1111-2222',
            NULL,
            NULL,
            NULL,
            NULL,
            SYSDATE,
            NULL,
            'Y'
        );
        
        INSERT INTO POINT VALUES (
            a,
            DEFAULT
        );
    END LOOP;
    COMMIT;
END;
/

-- �Խñ� �ۼ�
DECLARE
    a NUMBER; -- ���� ����
    b NUMBER := 2;
    c NUMBER;
BEGIN
    FOR i IN 1..50 LOOP
        a := SEQ_POSTNO.NEXTVAL; -- ������ ���� ������ �� �Ҵ�
        c := SEQ_BNO.NEXTVAL;
        INSERT INTO POST VALUES (
            a,
            '�����Դϴ�' || a,
            '<h2>�Խñ� �Դϴ�</h2><h1>test</h1><h3><br></h3><h3>test</h3><h4>test</h4><h5>test</h5><h6>test</h6><p>test</p><p><br></p><p><strong>test</strong></p><p><br></p><p><em>test</em></p><p><br></p><p><del>test</del></p><p><br></p><p>test</p><div contenteditable="false"><hr></div><p><br></p><blockquote><p>test</p></blockquote><ul><li><p>test1</p></li><li><p>test2</p></li><li><p>test3</p></li></ul><ol><li><p>tset1</p></li><li><p>test2</p></li></ol><ul><li class="task-list-item checked" data-task="true" data-task-checked="true"><p>test1</p></li><li class="task-list-item" data-task="true"><p>tset2</p></li><li class="task-list-item checked" data-task="true" data-task-checked="true"><p>test3</p></li></ul><table><thead><tr><th><p>��ȣ</p></th><th><p>����</p></th><th><p>����</p></th></tr></thead><tbody><tr><td><p>1</p></td><td><p>test</p></td><td><p>test</p></td></tr></tbody></table>',
            SYSDATE,
            NULL,
            'Y'
        );
        
        INSERT INTO BOARD VALUES (
            c,
            a,
            a,
            b,
            DEFAULT
        );
        b := b + 1; -- ���� b ����
        IF b > 4 THEN -- b ���� 4�� �ʰ��ϸ� 2�� �ʱ�ȭ
            b := 2;
        END IF;
    END LOOP;
    COMMIT;
END;