export function catchRouteError(f) {
  return (req, res, next) => {
    f(req, res, next).catch(next);
  };
}
