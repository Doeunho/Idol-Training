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
                TimeText.text = "애니메이션 클립을 찾을 수 없습니다.";
            }
        }
        else
        {
            Debug.LogError("Animation 또는 Text 컴포넌트가 할당되지 않았습니다.");
        }
    }

}
