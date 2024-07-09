using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class FadeController : MonoBehaviour
{
    public Image fadeImage;  // 페이드 효과에 사용할 이미지
    public float fadeDuration = 1f;  // 페이드아웃 지속 시간

    private CanvasGroup canvasGroup;

    private void Start()
    {
        // CanvasGroup 컴포넌트 추가 및 초기 설정
        canvasGroup = fadeImage.GetComponent<CanvasGroup>();
        if (canvasGroup == null)
        {
            canvasGroup = fadeImage.gameObject.AddComponent<CanvasGroup>();
        }

        // CanvasGroup 초기 설정
        canvasGroup.alpha = 1f;
        canvasGroup.blocksRaycasts = false; // Raycast를 차단하지 않도록 설정

        // 화면에 보이지 않도록 초기 설정
        fadeImage.gameObject.SetActive(false);

    }

    public void StartFadeOut()
    {
        // 이미지를 활성화하고 페이드아웃 시작
        fadeImage.gameObject.SetActive(true);
        StartCoroutine(FadeOutAfterDelay(1f));  // 2초 후 페이드아웃 시작
    }

    private IEnumerator FadeOutAfterDelay(float delay)
    {
        // 지정된 시간(2초) 동안 대기
        yield return new WaitForSeconds(delay);

        // 페이드아웃 실행
        float startAlpha = 1f;
        float endAlpha = 0f;
        float elapsedTime = 0;

        while (elapsedTime < fadeDuration)
        {
            elapsedTime += Time.deltaTime;
            float alpha = Mathf.Lerp(startAlpha, endAlpha, elapsedTime / fadeDuration);
            canvasGroup.alpha = alpha;
            yield return null;
        }

        // 페이드 완료 후 알파값을 완전히 0으로 설정하고 이미지를 비활성화
        canvasGroup.alpha = 0f;
        fadeImage.gameObject.SetActive(false);
    }
}
