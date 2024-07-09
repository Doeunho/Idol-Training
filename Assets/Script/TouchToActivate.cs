using UnityEngine;

public class TouchToToggle : MonoBehaviour
{
    public GameObject[] objectsToToggle; // ����� ������Ʈ �迭

    void Update()
    {
        // ����ڰ� ȭ���� ��ġ�ϰų� Ŭ���ϸ�
        if (Input.GetMouseButtonDown(0)) // 0�� ���콺 ���� ��ư �Ǵ� ��ġ
        {
            // �迭�� �ִ� ��� ������Ʈ�� Ȱ��ȭ ���¸� �����մϴ�.
            foreach (GameObject obj in objectsToToggle)
            {
                if (obj != null)
                    obj.SetActive(!obj.activeSelf);
            }
        }
    }
}
