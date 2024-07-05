using UnityEngine;
using Cinemachine;
using UnityEngine.UI;
using System.Collections;
using Unity.VisualScripting;

public class ActivateBlendList : MonoBehaviour
{
    public CinemachineBlendListCamera blendListCamera; // Blend List Camera 참조
    public Button activateButton;                      // 버튼 참조
    public Animator characterAnimator;                 // 캐릭터의 Animator
    public string animationTrigger;                    // 재생할 애니메이션 트리거 이름

    public float delay;

    public GameObject targetObject;

    /*
    void Start()
    {
        // 버튼 클릭 이벤트에 메서드 등록
        if (activateButton != null)
        {
            activateButton.onClick.AddListener(ActivateCameraAndAnimation);
        }

        // 버튼 클릭 이벤트에 메서드 등록
        if (activateButton != null)
        {
            activateButton.onClick.AddListener(OnButtonClick);
        }

    }
    */

    public void OnButtonClick()
    {
        // 코루틴 시작
        StartCoroutine(ActivateObject());
    }

    IEnumerator ActivateObject()
    {
        // 지연 시간만큼 대기
        yield return new WaitForSeconds(delay);

        // 타겟 오브젝트 활성화
        targetObject.SetActive(true);
    }

    public void ActivateCameraAndAnimation()
    {
        // Blend List Camera 활성화
        if (blendListCamera != null)
        {
            blendListCamera.Priority = 10; // 우선 순위 높여서 활성화
            
        }

        // 애니메이션 트리거 설정하여 애니메이션 재생
        if (characterAnimator != null && !string.IsNullOrEmpty(animationTrigger))
        {
            characterAnimator.SetTrigger(animationTrigger);
        }
    }
}
