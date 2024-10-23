using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using Cysharp.Threading.Tasks;
using System;

public class FadeController : MonoBehaviour
{
    public Image fadeImage;  // ���̵� ȿ���� ����� �̹���
    public float fadeDuration;  // ���̵�ƿ� ���� �ð�

    private CanvasGroup canvasGroup;

    private async void Start()
    {
        canvasGroup = fadeImage.GetComponent<CanvasGroup>();
        if (canvasGroup == null)
        {
            canvasGroup = fadeImage.gameObject.AddComponent<CanvasGroup>();
        }
        canvasGroup.alpha = 1f;
        canvasGroup.blocksRaycasts = false;
        fadeImage.gameObject.SetActive(false);

    }

    public async UniTask StartFadeOut()
    {
        fadeImage.gameObject.SetActive(true);
        await FadeOutAfterDelay(1f).AttachExternalCancellation(this.GetCancellationTokenOnDestroy());
    }

    private async UniTask FadeOutAfterDelay(float delay)
    {
        await UniTask.Delay(TimeSpan.FromSeconds(delay));

        float startAlpha = 1f;
        float endAlpha = 0f;
        float elapsedTime = 0;

        while (elapsedTime < fadeDuration)
        {
            elapsedTime += Time.deltaTime;
            float alpha = Mathf.Lerp(startAlpha, endAlpha, elapsedTime / fadeDuration);
            canvasGroup.alpha = alpha;
            await UniTask.Yield();
        }

        canvasGroup.alpha = 0f;
        fadeImage.gameObject.SetActive(false);
    }
}
