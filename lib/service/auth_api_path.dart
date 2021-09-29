class APIPath {
  static String job(String uid, String jobId) => '/users/$uid/jobs/$job';
  static String jobs(String uid) => "/users/$uid/jobs";
}
