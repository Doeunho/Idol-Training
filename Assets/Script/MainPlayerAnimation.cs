using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainPlayerAnimation : MonoBehaviour
{
    //���� ĳ���� �ִϸ��̼� (�, ������)
    //��Ʈ�ѷ��� �����Ѱ� ���, ĳ���� �����鸸 �ٸ���


    public Transform playerTransform; // �÷��̾��� Transform
    public Vector3 offset;            // ī�޶�� �÷��̾� ���� ������
    public Transform cameraTransform; // ī�޶��� Transform

    void LateUpdate()
    {
        if (playerTransform != null)
        {
            // �÷��̾� ��ġ�� �������� ���Ͽ� ī�޶� ��ġ�� ����
            transform.position = playerTransform.position + offset;
        }
    }


    void Update()
    {
        if (cameraTransform != null)
        {
            // ī�޶��� ��ġ�� �ٶ󺸵��� ȸ��
            Vector3 direction = cameraTransform.position - transform.position;
            direction.y = 0; // ���� ȸ���� �ϵ��� y�� ������ ����
            transform.rotation = Quaternion.LookRotation(direction);
        }
    }

}
