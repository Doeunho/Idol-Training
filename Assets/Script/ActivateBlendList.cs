using UnityEngine;
using Cinemachine;
using UnityEngine.UI;
using System.Collections;
using Unity.VisualScripting;

public class ActivateBlendList : MonoBehaviour
{
    public CinemachineBlendListCamera blendListCamera; // Blend List Camera 참조
    public CinemachineVirtualCamera initialCamera;     // 초기 위치 카메라 참조
    public Button activateButton;                      // 버튼 참조
    public Animator Mao_characterAnimator;             // 캐릭터의 Animator
    public Animator Makoto_characterAnimator;          // 캐릭터의 Animator
    public Animator Hokuto_characterAnimator;          // 캐릭터의 Animator

    public string animationTrigger;                    // 재생할 애니메이션 트리거 이름

    public float delay;
    public float blendDuration = 3.0f;                 // 블렌드 리스트 카메라 전환 시간

    public GameObject targetObject;

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

    public void MaoActivateCameraAndAnimation()
    {
        StartCoroutine(ActivateCameraAndAnimation(Mao_characterAnimator));
    }

    public void MakotoActivateCameraAndAnimation()
    {
        StartCoroutine(ActivateCameraAndAnimation(Makoto_characterAnimator));
    }

    public void HokutoActivateCameraAndAnimation()
    {
        StartCoroutine(ActivateCameraAndAnimation(Hokuto_characterAnimator));
    }

    private IEnumerator ActivateCameraAndAnimation(Animator characterAnimator)
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

        // 블렌드 리스트 카메라 전환 시간 동안 대기
        yield return new WaitForSeconds(blendDuration);

        // 초기 카메라로 되돌리기
        if (initialCamera != null)
        {
            blendListCamera.Priority = 5; // 블렌드 리스트 카메라 우선 순위 낮추기
            initialCamera.Priority = 10; // 초기 카메라 우선 순위 높이기
        }

        // 애니메이션 종료 후 초기화 (필요한 경우)
        yield return new WaitForSeconds(2.0f); // 애니메이션이 끝난 후 대기 시간 조절
        if (characterAnimator != null)
        {
            characterAnimator.ResetTrigger(animationTrigger); // 트리거 초기화
        }
    }
}
