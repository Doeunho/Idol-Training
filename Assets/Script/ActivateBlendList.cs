using UnityEngine;
using Cinemachine;
using UnityEngine.UI;
using System.Collections;
using Unity.VisualScripting;
using Cysharp.Threading.Tasks;

public class ActivateBlendList : MonoBehaviour
{
    public CinemachineBlendListCamera blendListCamera; // Blend List Camera 참조
    public CinemachineVirtualCamera initialCamera;     // 초기 위치 카메라 참조
    public Button activateButton;                      // 버튼 참조
    public Animator Mao_characterAnimator;             // 캐릭터의 Animator
    public string animationTrigger;                    // 재생할 애니메이션 트리거 이름

    public float delay;
    public float blendDuration = 3.0f;                 // 블렌드 리스트 카메라 전환 시간

    public GameObject targetObject;

    public async void OnButtonClick()
    {
        await ActivateObject();
    }

    private async UniTask ActivateObject()
    {
        await UniTask.Delay((int)delay * 1000);
        targetObject.SetActive(true);
    }

    public async void MaoActivateCamera()
    {
        await ActivateCameraAndAnimation(Mao_characterAnimator);
        await ActivateObject();
    }

    private async UniTask ActivateCameraAndAnimation(Animator characterAnimator)
    {
        // Blend List Camera 활성화
        if (blendListCamera != null)
        {
            blendListCamera.Priority = 10;
        }

        // 애니메이션 트리거 설정
        if (characterAnimator != null && !string.IsNullOrEmpty(animationTrigger))
        {
            characterAnimator.SetTrigger(animationTrigger);
        }

        // 블렌드 리스트 카메라 전환 시간 대기
        await UniTask.Delay((int)(blendDuration));

        // 초기 카메라로 되돌리기
        if (initialCamera != null)
        {
            blendListCamera.Priority = 5;
            initialCamera.Priority = 10;
        }

        // 애니메이션 종료 후 초기화
        await UniTask.Delay(2000); // 2초 대기
        if (characterAnimator != null)
        {
            characterAnimator.ResetTrigger(animationTrigger);
        }
    }
}
