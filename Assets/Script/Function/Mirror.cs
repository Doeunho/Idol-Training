using UnityEngine;

public class Mirror : MonoBehaviour
{
    public Camera mainCamera;
    public Camera mirrorCamera;

    void LateUpdate()
    {
        Vector3 cameraPositionInMirrorSpace = transform.InverseTransformPoint(mainCamera.transform.position);
        cameraPositionInMirrorSpace = new Vector3(cameraPositionInMirrorSpace.x, -cameraPositionInMirrorSpace.y, cameraPositionInMirrorSpace.z);
        mirrorCamera.transform.position = transform.TransformPoint(cameraPositionInMirrorSpace);

        Vector3 cameraEulerAnglesInMirrorSpace = transform.InverseTransformDirection(mainCamera.transform.forward);
        cameraEulerAnglesInMirrorSpace = new Vector3(cameraEulerAnglesInMirrorSpace.x, -cameraEulerAnglesInMirrorSpace.y, cameraEulerAnglesInMirrorSpace.z);
        mirrorCamera.transform.rotation = Quaternion.LookRotation(transform.TransformDirection(cameraEulerAnglesInMirrorSpace), Vector3.up);
    }
}
