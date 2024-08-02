using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ExpRank : MonoBehaviour
{
    public enum InfoType { exp, coin }
    public InfoType type;

    Slider Expslider;
    Text myText;

    private void Awake()
    {
        Expslider = GetComponent<Slider>();
        myText = GetComponent<Text>();
    }

    private void LateUpdate()
    {
        switch (type)
        {
            case InfoType.exp:
                int curExp = GameManager.instance.exp;
                int mexExp = GameManager.instance.nextexp[Mathf.Min(GameManager.instance.rank, GameManager.instance.nextexp.Length - 1)];
                Expslider.value = curExp / mexExp;
                break;
            case InfoType.coin:
                myText.text = string.Format("{0:F0}", GameManager.instance.coin);
                break;
        }
    }
}
