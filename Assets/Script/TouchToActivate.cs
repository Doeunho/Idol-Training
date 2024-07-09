using UnityEngine;

public class TouchToToggle : MonoBehaviour
{
    public GameObject[] objectsToToggle; // 토글할 오브젝트 배열

    void Update()
    {
        // 사용자가 화면을 터치하거나 클릭하면
        if (Input.GetMouseButtonDown(0)) // 0은 마우스 왼쪽 버튼 또는 터치
        {
            // 배열에 있는 모든 오브젝트의 활성화 상태를 반전합니다.
            foreach (GameObject obj in objectsToToggle)
            {
                if (obj != null)
                    obj.SetActive(!obj.activeSelf);
            }
        }
    }
}
