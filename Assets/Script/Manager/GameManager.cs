using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static Cinemachine.DocumentationSortingAttribute;

public class GameManager : MonoBehaviour
{
    public static GameManager instance;
    [Header("PLAYER INFO")]
    public int coin;
    public int exp;
    public int rank;
    public int[] nextexp = { 200 };


    //���� ����, ���� �ڷ�ƾ �����
    //
    //����� ���� 30�� ȹ�� �� ��ŸƮ ��ư Ŭ�� �ȵǰ�


    void Awake()
    {
        instance = this;
    }

    public void Getexp()
    {
        exp++;
        if (exp == nextexp[Mathf.Min(rank, nextexp.Length - 1)])
        {
            rank++;
            exp = 0;
        }
    }

    public void OnCilck_TrainingStart1()
    {

    }
}
