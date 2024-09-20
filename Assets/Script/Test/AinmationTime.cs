using System.Collections;
using System.Collections.Generic;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class AinmationTime : MonoBehaviour
{

    public AnimationClip Animation;
    public Text TimeText;

    // Start is called before the first frame update
    void Start()
    {
        AnimationTimePlay();
    }

    private void AnimationTimePlay()
    {
        if (Animation != null && TimeText != null)
        {
            if (Animation != null )
            {
                float totalTime = Animation.length;
                TimeText.text = $"Time : {totalTime:F2}";
            }
            else
            {
                TimeText.text = "�ִϸ��̼� Ŭ���� ã�� �� �����ϴ�.";
            }
        }
        else
        {
            Debug.LogError("Animation �Ǵ� Text ������Ʈ�� �Ҵ���� �ʾҽ��ϴ�.");
        }
    }

}
