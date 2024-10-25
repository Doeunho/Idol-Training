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


    //게임 시작, 종료 코루틴 만들기
    //
    //종료시 코인 30개 획득 후 스타트 버튼 클릭 안되게


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
